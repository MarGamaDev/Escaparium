class_name PlayerController
extends CharacterBody3D

@export var horizontal_speed: float = 1;
@export var sprint_multiplier: float = 2;
@export var flop_force: float = 1;
@export var jump_force: float = 2;
@export var air_control_multiplier: float = 0.1;

@onready var camera: Camera3D = $"Camera Arm/Camera3D";

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

var input_vector := Vector2.ZERO;
var is_sprinting := false;
var is_grounded := false;

func _process(delta: float) -> void:
	_take_input()
	_check_ground()

func _physics_process(delta: float) -> void:
	_apply_movement(delta)

func _take_input() -> void:
	input_vector = Input.get_vector("Move_Left","Move_Right","Move_Back","Move_Forward");
	
	is_sprinting = Input.is_action_pressed("Sprint");

func _check_ground() -> void:
	return

func _apply_movement(delta: float) -> void:
	var cam_translated_forward := Vector3(camera.global_position.x - global_position.x, 0, camera.global_position.z - global_position.z).normalized();
	#var move_direction: Vector3 = input_vector.ro
	
	if input_vector == Vector2.ZERO:
		return;
	#if input_vector != Vector2.ZERO:
	velocity.x = input_vector.x;
	velocity.y = input_vector.y;
	print(velocity);
	#apply gravity
	#apply jump
	move_and_slide()
