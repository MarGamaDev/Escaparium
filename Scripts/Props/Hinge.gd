class_name ShelfHinge
extends Node3D

@export var screwdriver_group: String = "screwdriver";
signal hinge_unscrewed;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_groups().has(screwdriver_group):
		visible = false;
		hinge_unscrewed.emit();
