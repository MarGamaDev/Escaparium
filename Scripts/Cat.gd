class_name Cat
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $CATFIXEDcatnip/AnimationPlayer

@export var sleep_time: float = 5;
@export var eat_time: float = 5;
@export var catnip_time: float = 5;

enum State {
	SLEEPING,
	IDLE,
	MOVING,
	CATNIP,
	EATING
}

var current_state = State.SLEEPING;

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide()

func _on_navigation_agent_3d_navigation_finished() -> void:
	pass # Replace with function body.

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
