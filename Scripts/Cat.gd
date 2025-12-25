class_name Cat
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $CATFIXEDcatnip/AnimationPlayer

@export var sleep_time: float = 15;
@export var eat_time: float = 5;
@export var catnip_time: float = 10;
@export var idle_time: float = 1.5;

@export var speed: float = 5;
@export var turn_speed: float = 1;
@export var fish_till_sleep: int = 7;

var timer: float = 0;
var fish_eaten: int = 0;
var is_going_to_sleep: bool = false;

enum State {
	TRANSITIONING,
	SLEEPING,
	IDLE,
	MOVING,
	CATNIP,
	EATING
}

var current_state: State = State.SLEEPING;
var transition_to_state: State;
var target: Node3D;

func _ready() -> void:
	animation_player.play("Sleeping");

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta;
	
	match current_state:
		State.SLEEPING:
			_on_sleeping(delta);
		State.IDLE:
			_on_idle(delta);
		State.MOVING:
			_on_moving(delta);
		State.CATNIP:
			_on_catnip(delta);
		State.EATING:
			_on_eating(delta);
	
	move_and_slide();

func _turn_towards_target(delta: float):
	var target_direction = (target.global_position - global_position).normalized();
	var forward = Vector3(basis.z.x, 0, basis.z.z).rotated(Vector3.UP, 90);
	var angle = forward.angle_to(Vector3(target_direction.x, 0 , target_direction.z));
	angle = clampf(angle, -turn_speed * delta, turn_speed * delta);
	global_rotate(Vector3.UP, angle);

func _determine_target():
	var fish = get_tree().get_nodes_in_group("fish");
	var maybe_target;
	var has_valid_target := false;
	
	if fish.is_empty():
		return;
	
	while !has_valid_target:
		maybe_target = fish.pick_random();
		navigation_agent_3d.target_position = maybe_target.position;
		
		if navigation_agent_3d.is_target_reachable():
			timer = 0;
			current_state = State.MOVING;
			has_valid_target = true;
			target = maybe_target;
		else:
			fish.erase(maybe_target)
		
		if fish.is_empty():
			break;

func _on_moving(delta: float) -> void:
	print("moving");
	print(target)
	if target == null || !navigation_agent_3d.is_target_reachable():
		current_state = State.IDLE;
		target = null;
		return;
	else:
		navigation_agent_3d.target_position = target.global_position;
		var next_position = navigation_agent_3d.get_next_path_position();
		var direction = (next_position - global_position).normalized();
		velocity = direction * speed;
		_turn_towards_target(delta);

func _on_idle(delta: float):
	print("idle");
	
	velocity = Vector3.ZERO;
	timer += delta;
	
	if timer >= idle_time:
		_determine_target();

func _on_sleeping(delta: float):
	print("sleeping");
	
	timer += delta;
	
	if timer >= sleep_time:
		current_state = State.TRANSITIONING;
		transition_to_state = State.IDLE;
		animation_player.play("StandingUpFromSleep");
		timer = 0;

func _on_catnip(delta: float):
	print("catnip")
	
	timer += delta;
	
	if timer >= catnip_time:
		current_state = State.TRANSITIONING;
		transition_to_state = State.IDLE;
		animation_player.play("GettingUpFromCatnip");
		timer = 0;

func _on_eating(delta: float):
	print("eating")
	
	timer += delta;
	
	if timer >= eat_time:
		fish_eaten += 1;
		if fish_eaten == fish_till_sleep:
			current_state = State.TRANSITIONING;
			transition_to_state = State.SLEEPING;
			is_going_to_sleep = true;
			animation_player.play("StandingUpFromSleep", -1, 1, true);
		else:
			current_state = State.IDLE;
			animation_player.play("STANDING_IDLE");
		timer = 0;

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"StandingUpFromSleep":
			if !is_going_to_sleep:
				animation_player.play("STANDING_IDLE");
			else:
				is_going_to_sleep = false;
				animation_player.play("Sleeping");
		"GettingUpFromCatnip":
			animation_player.play("STANDING_IDLE");
		"Catnip":
			pass
	
	current_state = transition_to_state;

func _on_navigation_agent_3d_navigation_finished() -> void:
	print("arrived");
	if !target:
		return;
	print(target.name);
	
	if target.get_groups().has("catnip"):
		current_state = State.TRANSITIONING;
		transition_to_state = State.CATNIP;
		animation_player.play("Catnip");
	elif target.get_groups().has("player"):
		(target as PlayerController).die();
		current_state = State.EATING;
		animation_player.play("Eating");
	else:
		target.queue_free();
		current_state = State.EATING;
		animation_player.play("Eating");
	target = null;

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if is_on_floor():
		velocity = velocity.move_toward(safe_velocity, 0.25)
