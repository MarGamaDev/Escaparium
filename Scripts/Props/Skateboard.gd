class_name Skateboard
extends CharacterBody3D

@export var rollables: Array[Node3D];
@export var circumference: float;
@export var full_rotation_value: float = 360;
@export var mass: float = 1;
@export var drag: float = 0.8;

@onready var fishtank_point: Node3D = $"Fishtank Point";
@onready var fan_point: Node3D = $"Fan Point";

signal fan_picked_up(fan: String);

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var start_y: float;
var last_position: Vector3;

var fishtank: FishTank;
var fan: Fan;

func _ready() -> void:
	last_position = position;
	start_y = position.y;

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
	
	for i in get_slide_collision_count():
		var coll := get_slide_collision(i);
		if coll.get_collider() is Fan:
			pickup_fan(coll.get_collider() as Fan);
			fan_picked_up.emit("fan");
	
	# dont fall through floor
	if position.y < start_y:
		position.y = start_y;

func apply_force(force: Vector3) -> void:
	velocity += Vector3(force.x, 0, force.z);

func acquire_fishtank(tank: Node3D) -> void:
	add_collision_exception_with(tank);
	fishtank = tank;
	if fan:
		fishtank.add_collision_exception_with(fan);
	tank.global_position = fishtank_point.global_position;
	tank.global_rotation = fishtank_point.global_rotation;
	tank.reparent(fishtank_point);

func pickup_fan(fan: Fan) -> void:
	fan.get_picked_up();
	add_collision_exception_with(fan);
	if fishtank:
		fan.add_collision_exception_with(fishtank);
	fan.reparent(fan_point);
	fan.position = Vector3.ZERO;
	fan.rotation = Vector3.ZERO;
