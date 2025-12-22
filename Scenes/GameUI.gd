class_name GameUI
extends Control

@onready var breath_timer: TextureProgressBar = $"Breath Timer";

func update_breath_timer(percent: float) -> void:
	breath_timer.value = percent * 100;

func toggle_game_ui(game_state: GameManager.GameState) -> void:
	match game_state:
		GameManager.GameState.FISHTANK:
			visible = false;
		GameManager.GameState.PLAYING:
			visible = true;
