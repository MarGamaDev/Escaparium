class_name GameManager
extends Node

@onready var spawn_cam: Camera3D = $"Spawn Cam";
@onready var spawn_point: Node3D = $"Player Spawn Point";
@onready var fish_tank: FishTank = $Furniture/Fishtank;

@export var breath_max_time: float = 30;

signal update_timer(time: float);
signal update_game_state(game_state: GameState);

enum GameState {
	FISHTANK,
	PLAYING
}

var current_game_state: GameState = GameState.FISHTANK;
var global_flags: Array[String];

var player_scene = preload("res://Player/Player.tscn");
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
		fish_tank.play_jump_animation();
		current_game_state = GameState.PLAYING;

func _run_playing_state(delta: float) -> void:
	breath_timer -= delta;
	update_timer.emit(breath_timer / breath_max_time)

func _switch_game_state(state: GameState) -> void:
	current_game_state = state;
	update_game_state.emit(current_game_state);

func _spawn_player() -> void:
	player = player_scene.instantiate();
	player.position = spawn_point.position;
	player.add_flags(global_flags);
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
