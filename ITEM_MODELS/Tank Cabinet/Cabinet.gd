extends Node3D

@onready var animation_player = $AnimationPlayer;

func on_interact() -> void:
	animation_player.play("open");
	pass
