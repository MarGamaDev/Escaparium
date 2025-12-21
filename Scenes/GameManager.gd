class_name GameManager
extends Node

@onready var spawn_cam: Camera3D = $"Spawn Cam";
@onready var spawn_point: Node3D = $"Player Spawn Point";
@onready var fish_tank: FishTank = $Furniture/Fishtank;

var player_scene = preload("res://Player/Player.tscn");

var player: PlayerController;

enum GameState {
	FISHTANK,
	PLAYING
}

var current_game_state: GameState = GameState.FISHTANK;

func spawn_player() -> void:
	fish_tank.reset_animation();
	player = player_scene.instantiate();
	player.position = spawn_point.position;
	add_child(player);

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		if current_game_state == GameState.FISHTANK:
			fish_tank.play_jump_animation();
			current_game_state = GameState.PLAYING;
