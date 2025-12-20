class_name ThirdPersonCamera
extends Node3D

@export var mouse_sensitivity: float = 1;
@export_range(-90.0, 0.0, 0.1, "radiens_as_degrees") var min_vertical_angle: float = -70;
@export_range(0.0, 90.0, 0.1, "radiens_as_degrees") var max_vertical_angle: float = 5;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func do_vertical_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity;
		rotation.x = clamp(rotation.x, deg_to_rad(min_vertical_angle), deg_to_rad(max_vertical_angle));

func do_horizontal_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity;
		rotation.y = wrapf(rotation.y, 0.0, TAU);

func reset_horizontal_rotation() -> void:
	rotation.y = 0;
