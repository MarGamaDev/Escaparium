class_name GameManager
extends Node

@onready var spawn_cam: Camera3D = $"Furniture/Fishtank/Spawn Cam";
@onready var spawn_point: RayCast3D = $"Furniture/Fishtank/Player Spawn Point";
@onready var fish_tank: FishTank = $Furniture/Fishtank;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;

@export var breath_max_time: float = 30;
@export var lives: int = 5;
@export var win_flags: Array[String];

signal update_timer(time: float);
signal update_game_state(game_state: GameState);
signal out_of_breath;
signal jump_out_of_tank;
signal prying_done(tank: Node3D);

var fork: RigidBody3D;

enum GameState {
	FISHTANK,
	PLAYING,
	OVER
}

enum EndState {
	BROKEN,
	EMPTY,
	WIN
}

var current_game_state: GameState = GameState.FISHTANK;
var global_flags: Array[String];

var dead_fish_scene = preload("res://Props/Dead Fish.tscn");
var player_scene = preload("res://Props/Player.tscn");
var player: PlayerController;

var breath_timer: float = 0;

func _ready() -> void:
	go_to_fishtank_state();

func _process(delta: float) -> void:
	match current_game_state:
		GameState.FISHTANK:
			_run_fishtank_state(delta);
		GameState.PLAYING:
			_run_playing_state(delta);

func _run_fishtank_state(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		jump_out_of_tank.emit();
		current_game_state = GameState.PLAYING;

func _run_playing_state(delta: float) -> void:
	breath_timer -= delta;
	update_timer.emit(breath_timer / breath_max_time);
	if breath_timer <= 0:
		out_of_breath.emit();

func _switch_game_state(state: GameState) -> void:
	current_game_state = state;
	update_game_state.emit(current_game_state);

func _spawn_player() -> void:
	var hit_point: Vector3 = spawn_point.get_collision_point();
	player = player_scene.instantiate();
	player.position = hit_point;
	player.rotation = spawn_point.rotation;
	
	player.add_flags(global_flags);
	player.player_death.connect(kill_player);
	out_of_breath.connect(player.die);
	
	add_child(player);

func go_to_playing_state() -> void:
	breath_timer = breath_max_time;
	fish_tank.reset_animation();
	_switch_game_state(GameState.PLAYING);
	_spawn_player();

func go_to_fishtank_state() -> void:
	_switch_game_state(GameState.FISHTANK);

func  add_global_flag(flag: String) -> void:
	global_flags.append(flag);

func  remove_global_flag(flag: String) -> void:
	global_flags.erase(flag);

func kill_player() -> void:
	if !player:
		return;
	
	#spawn corpse
	var corpse: RigidBody3D = dead_fish_scene.instantiate();
	corpse.position = player.position;
	corpse.rotation = player.model.rotation;
	corpse.freeze = false;
	add_child(corpse);
	(corpse.find_child("body") as DeadFish). do_dying_thing();
	
	#despawn player
	player.player_death.disconnect(kill_player);
	out_of_breath.disconnect(player.die);
	remove_child(player);
	player.queue_free();
	player = null;
	
	lives -= 1;
	fish_tank.update_lives(lives);
	if lives <= 0:
		reach_end_state(EndState.EMPTY);
	else:
		go_to_fishtank_state();

func reach_end_state(end_state: EndState) -> void:
	_switch_game_state(GameState.OVER);
	match end_state:
		EndState.EMPTY:
			print("you ran out of fish");
			get_tree().change_scene_to_file("res://Scenes/Defeat Empty.tscn");
		EndState.BROKEN:
			print("you broke the tank");
			get_tree().change_scene_to_file("res://Scenes/Defeat Broken.tscn");
		EndState.WIN:
			print("CONGRATS YIPPEEEEEE");
			get_tree().change_scene_to_file("res://Scenes/Win.tscn");

func _on_skateboard_fishtank_area_body_entered(body: Node3D) -> void:
	if body is Skateboard:
		print("skateboard in position")
		add_global_flag("skateboard");

func _on_skateboard_fishtank_area_body_exited(body: Node3D) -> void:
	if body is Skateboard:
		print("skateboard out of position")
		add_global_flag("skateboard");

func finish_prying() -> void:
	print("finished prying")
	if global_flags.has("skateboard"):
		prying_done.emit(fish_tank);
		add_global_flag("fishtank");
	else:
		reach_end_state(EndState.BROKEN);

func _on_fork_point_filled(body: Node3D) -> void:
	print("fork placed");
	fork = (body as RigidBody3D);
	fork.connect("body_entered", pry_down);

func pry_down(body: Node) -> void:
	if !body is Interactable:
		return
		
	print("prying fishtank down");
	fork.disconnect("body_entered", pry_down);
	animation_player.play("pry_down_fishtank");

func release_fork() -> void:
	print("fork released");
	fork.reparent(get_tree().root);
	fork.grabbable = true;
	fork.freeze = false;

func check_if_win() -> void:
	for flag in global_flags:
		if win_flags.has(flag):
			win_flags.erase(flag);
	
	if win_flags.is_empty():
		reach_end_state(EndState.WIN);
	else:
		reach_end_state(EndState.BROKEN);
