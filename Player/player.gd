class_name PlayerController
extends CharacterBody3D

@export var horizontal_speed: float = 1;
@export var sprint_multiplier: float = 2;
@export var flop_force: float = 1;
@export var jump_force: float = 2;
@export var air_control_multiplier: float = 0.1;
@export var fish_mass: float = 1;
@export var fish_drag: float = 1;

@onready var camera: Camera3D = $"Camera Arm/Camera3D";

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

var input_vector := Vector2.ZERO;
var is_sprinting := false;

func _process(delta: float) -> void:
	_take_input()
	_check_ground()
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_force;
			print("jumping")

func _physics_process(delta: float) -> void:
	#apply gravity
	velocity.y -= gravity * fish_mass * delta;
	_apply_movement(delta)

func _take_input() -> void:
	input_vector = Input.get_vector("Move_Right","Move_Left","Move_Back","Move_Forward");
	
	is_sprinting = Input.is_action_pressed("Sprint");

func _check_ground() -> void:
	return

func _apply_movement(delta: float) -> void:
	var cam_translated_forward := Vector3(camera.global_position.x - global_position.x, 0, camera.global_position.z - global_position.z).normalized();
	var move_vector := Vector3.ZERO;
	
	if input_vector == Vector2.ZERO:
		return
	move_vector.x = input_vector.x;
	move_vector.z = input_vector.y;
	
	var forward_angle :float = (Vector3.FORWARD.signed_angle_to(cam_translated_forward, Vector3.UP));
	var rotated_movement = move_vector.rotated(Vector3.UP, forward_angle);
	
	rotated_movement *= flop_force * delta;
	if !is_on_floor():
		rotated_movement *= air_control_multiplier;
	
	if is_sprinting:
		rotated_movement *= sprint_multiplier;
	
	#apply movement
	velocity += Vector3(rotated_movement.x, 0, rotated_movement.z);
	
	#apply floor drag
	if is_on_floor():
		velocity *= fish_drag
	
	move_and_slide()
