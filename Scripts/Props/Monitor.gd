class_name Monitor
extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@export var hit_amount: int = 3;

signal on_hits_achieved;

func on_body_entered(body: Node3D) -> void:
	hit_amount -= 1;
	animation_player.play("hit");
	
	if hit_amount == 0:
		on_hits_achieved.emit();
