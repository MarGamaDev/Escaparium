class_name FishTank
extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
signal animation_finished;

func play_jump_animation() -> void:
	animation_player.play("send_off_to_war");

func on_animation_finished() -> void:
	animation_finished.emit();

func reset_animation() -> void:
	animation_player.play("RESET");

func update_lives(amount: int) -> void:
	pass
