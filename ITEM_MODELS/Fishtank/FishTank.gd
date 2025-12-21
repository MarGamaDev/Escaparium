class_name FishTank
extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		animation_player.play("send_off_to_war");
