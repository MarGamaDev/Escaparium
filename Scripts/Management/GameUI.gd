class_name GameUI
extends Control

@onready var breath_timer: TextureProgressBar = $"Breath Timer";
@onready var jump_prompt: Sprite2D = $Leavetankprompt;
@onready var jump_prompt_animator: AnimationPlayer = $Leavetankprompt/AnimationPlayer;

func update_breath_timer(percent: float) -> void:
	var fill = breath_timer.max_value - breath_timer.min_value;
	breath_timer.value = breath_timer.min_value + (percent * fill);

func toggle_game_ui(game_state: GameManager.GameState) -> void:
	match game_state:
		GameManager.GameState.FISHTANK:
			breath_timer.visible = false;
			jump_prompt.visible = true;
			jump_prompt_animator.play("RESET");
		GameManager.GameState.PLAYING:
			breath_timer.visible = true;
			jump_prompt.visible = false;

func fade_out_prompt() -> void:
	jump_prompt_animator.play("fade_out");
