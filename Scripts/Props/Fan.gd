class_name Fan
extends RigidBody3D

var can_be_activated: bool = false;
signal attempt_win;

func get_picked_up() -> void:
	can_be_activated = true;
	lock_rotation = true;
	axis_lock_linear_x = true;
	axis_lock_linear_y = true;
	axis_lock_linear_z = true;


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Interactable:
		print("attempt to win");
		attempt_win.emit();
