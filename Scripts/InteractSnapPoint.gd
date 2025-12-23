class_name SnapPoint
extends Node3D

@export var item_group: String;
@export var snap_point_active: bool = true;

signal snap_point_filled;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !snap_point_active:
		return;
	
	if body.get_groups().has(item_group):
		(body as RigidBody3D).freeze = true;
		if body is Interactable:
			(body as Interactable).grabbable = false;
		body.reparent(self);
		body.position = Vector3.ZERO;
		body.rotation = Vector3.ZERO;
		snap_point_filled.emit();
