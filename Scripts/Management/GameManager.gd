class_name GameManager
extends Node

@onready var spawn_cam: Camera3D = $"Spawn Cam";
@onready var spawn_point: Node3D = $"Player Spawn Point";
@onready var fish_tank: FishTank = $Furniture/Fishtank;

@export var breath_max_time: float = 30;
@export var lives: int = 5;

signal update_timer(time: float);
signal update_game_state(game_state: GameState);
signal out_of_breath;
signal jump_out_of_tank;

enum GameState {
	FISHTANK,
	PLAYING,
	OVER
}

enum EndState {
	ESCAPE,
	BROKEN,
	EMPTY
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
	player = player_scene.instantiate();
	player.position = spawn_point.position;
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

func  add_global_flags(flags: Array[String]) -> void:
	global_flags.append_array(flags);

func  remove_global_flags(flags: Array[String]) -> void:
	for flag in flags:
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
			print("you lost");
