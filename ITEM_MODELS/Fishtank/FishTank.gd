class_name FishTank
extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;

func play_jump_animation() -> void:
	animation_player.play("send_off_to_war");
