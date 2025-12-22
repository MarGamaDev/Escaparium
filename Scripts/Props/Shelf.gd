class_name Shelf
extends RigidBody3D

@export var hinge_count: int = 2;
var current_hinges;

func _on_hinge_unscrewed() -> void:
	hinge_count -= 1;
	if hinge_count == 0:
		freeze = false;
