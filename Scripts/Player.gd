class_name PlayerController
extends CharacterBody3D

@onready var camera_pivot: ThirdPersonCamera =$"Camera Pivot";
@onready var camera: Camera3D = $"Camera Pivot/Camera Arm/Camera3D";
@onready var animation_tree: AnimationTree = $"Fishtopher Model/AnimationTree";
@onready var model: Node3D = $"Fishtopher Model";
@onready var collider: CollisionShape3D = $CollisionShape3D;
@onready var held_item_point: Node3D = $"Held Item Point";
@onready var jump_sfx: SmartSoundArrayPlayer = $"Jump Sounds"
@onready var step_sfx: SmartSoundArrayPlayer = $"Step Sounds"
@onready var land_sfx: SmartSoundArrayPlayer = $"Land Sounds"

@export var horizontal_speed: float = 1;
@export var sprint_multiplier: float = 2;
@export var flop_force: float = 1;
@export var jump_force: float = 2;
@export var max_speed: float = 0.1;
@export var fish_mass: float = 1;
@export var fish_drag: float = 1;
@export var yeet_force: float = 1;
@export var time_to_reset: float = 3;

signal player_death;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var flop_percent: float  = 0;
var input_vector := Vector2.ZERO;
var is_sprinting := false;
var is_aerial := true;

var interactables: Array[Node3D];
var interact_flags: Array[String];
var held_item: Node3D = null;

var reset_timer = 0;

func _ready() -> void:
	camera.make_current();

func _process(delta: float) -> void:
	_take_input(delta);
	_animate(delta);
	
	if held_item:
		var held_item_forward: Vector3 = held_item.global_position +(-camera.global_transform.basis.z.normalized());
		held_item.look_at(held_item_forward, Vector3.UP);

func _physics_process(delta: float) -> void:
	if is_aerial:
		if is_on_floor():
			land_sfx.play_random_from_array();
	
	is_aerial = ! is_on_floor();
	
	_apply_movement(delta)
	#apply gravity
	velocity.y -= gravity * fish_mass * delta;
	
	#apply floor drag
	if is_on_floor():
		velocity *= fish_drag
	
	#apply align model
	if velocity.x + velocity.z != 0:
		_rotate_model_to_forward()
		if is_on_floor() && !step_sfx.playing:
			step_sfx.play_random_from_array();
	
	#clamp velocity before applying
	var min_velocity: Vector3 = Vector3(-max_speed, -INF, -max_speed);
	var max_velocity: Vector3 = Vector3(max_speed, INF, max_speed);
	velocity = velocity.clamp(min_velocity, max_velocity);
	move_and_slide()
	
	#pushing physics
	for i in get_slide_collision_count():
		var item = get_slide_collision(i);
		if item.get_collider() is RigidBody3D:
			var impulse: Vector3 = -(velocity.length() * item.get_normal());
			(item.get_collider() as RigidBody3D).apply_central_impulse(impulse);
	
	#safeguard falling
	if position.y <= -0.1:
		position.y = 0.2;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_do_camera(event);

func _animate(delta: float) -> void:
	if !is_on_floor():
		return
	
	var horizontal_velocity: float = Vector2(velocity.x, velocity.z).length();
	if  horizontal_velocity > 0.4 :
		animation_tree.set("parameters/Move Blend/blend_amount", 1);
		flop_percent = 1;
	else:
		flop_percent -= 2 * delta;
		flop_percent = clamp(flop_percent, 0, 1);
		animation_tree.set("parameters/Move Blend/blend_amount", flop_percent);

func _do_camera(event: InputEvent) -> void:
	camera_pivot.do_vertical_rotation(event);
	camera_pivot.do_horizontal_rotation(event);

func _rotate_model_to_forward() -> void:
	model.rotation.y = camera_pivot.rotation.y + deg_to_rad(180);
	collider.rotation.y = camera_pivot.rotation.y + deg_to_rad(180);

func _take_input(delta: float) -> void:
	input_vector = Input.get_vector("Move_Right","Move_Left","Move_Back","Move_Forward");
	is_sprinting = Input.is_action_pressed("Sprint");
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_force;
			jump_sfx.play_random_from_array();
			animation_tree.set("parameters/Jump Oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	
	if Input.is_action_just_pressed("Interact"):
		if !held_item:
			_try_interact();
		else:
			_throw_item();
	
	if Input.is_action_pressed("Reset"):
		reset_timer += delta;
		
	if Input.is_action_just_released("Reset"):
		reset_timer = 0;
	
	if reset_timer >= time_to_reset:
		reset_timer = -1000;
		die();

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
	
	if is_sprinting:
		rotated_movement *= sprint_multiplier;
	
	#apply movement
	velocity += Vector3(rotated_movement.x, 0, rotated_movement.z);

func _try_interact() -> void:
	if interactables.is_empty():
		return;
	
	var closest_distance: float = INF;
	var closest_interactable: Interactable;
	for item in interactables:
		if item != held_item:
			if position.distance_to(item.position) < closest_distance:
				closest_distance = item.position.length();
				closest_interactable = item as Interactable;
	
	if closest_interactable == null:
		return;
	
	if closest_interactable.can_interact(interact_flags):
		closest_interactable._interact();
	
	if !held_item:
		if closest_interactable.can_grab():
			_grab_item(closest_interactable.grab());

func _grab_item(item: Node3D) -> void:
	if item is RigidBody3D:
		(item as RigidBody3D).freeze = true;
	
	item.position = held_item_point.global_position;
	item.reparent(held_item_point);
	held_item = item;

func _throw_item() -> void:
	if held_item is RigidBody3D:
		(held_item as RigidBody3D).freeze = false;
	
	held_item.reparent(get_tree().root)
	
	var yeet_vector: Vector3 = yeet_force * -camera.global_transform.basis.z.normalized();
	(held_item as RigidBody3D).apply_central_impulse(yeet_vector);
	held_item = null;

func _drop_item() -> void:
	if held_item is RigidBody3D:
		(held_item as RigidBody3D).freeze = false;
	
	held_item.reparent(get_tree().root)
	held_item = null;

func add_flags(flags: Array[String]) -> void:
	interact_flags.append_array(flags)

func remove_flags(flags: Array[String]) -> void:
	for item in flags:
		interact_flags.erase(item);

func _on_body_entered(body: Node3D) -> void:
	if interactables.has(body):
		return;
	if body is Interactable:
		interactables.append(body);

func _on_body_exited(body: Node3D) -> void:
	if interactables.has(body):
		interactables.erase(body);

func die() -> void:
	if held_item:
		_drop_item();
	
	player_death.emit();
