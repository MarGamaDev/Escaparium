class_name Monitor
extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@export var hit_amount: int = 3;

signal hit_target_reached;
signal hit_glass;

func on_body_entered(_body: Node3D) -> void:
	hit_amount -= 1;
	
	if hit_amount == 0:
		hit_target_reached.emit();
		animation_player.play("yeet");
	else:
		animation_player.play("hit");

func reach_glass() -> void:
	hit_glass.emit();
