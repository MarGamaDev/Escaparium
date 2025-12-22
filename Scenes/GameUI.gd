class_name GameUI
extends Control

@onready var breath_timer: TextureProgressBar = $"Breath Timer";

func update_breath_timer(percent: float) -> void:
	var fill = breath_timer.max_value - breath_timer.min_value;
	print(breath_timer.min_value + (percent * fill))
	breath_timer.value = breath_timer.min_value + (percent * fill);

func toggle_game_ui(game_state: GameManager.GameState) -> void:
	match game_state:
		GameManager.GameState.FISHTANK:
			visible = false;
		GameManager.GameState.PLAYING:
			visible = true;
