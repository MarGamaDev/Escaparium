class_name Skateboard
extends CharacterBody3D

@export var rollables: Array[Node3D];
@export var circumference: float;
@export var full_rotation_value: float = 360;
@export var mass: float = 1;
@export var drag: float = 0.8;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var last_position: Vector3;

func _ready() -> void:
	last_position = position;

func _physics_process(delta: float) -> void:
	#wheels
	var transposition = last_position - position;
	var distance_traveled: float = transposition.length() * sign(basis.x.dot(transposition))
	var rotation_to_apply_deg: float = (distance_traveled / circumference) * full_rotation_value;
	
	for item in rollables:
		item.rotation.z += deg_to_rad(rotation_to_apply_deg);
	
	velocity *= drag;
	velocity.y -= gravity * mass * delta;
	
	last_position = position;
	move_and_slide();
	position.z = last_position.z;

func apply_force(force: Vector3) -> void:
	velocity += Vector3(force.x, 0, force.z);
