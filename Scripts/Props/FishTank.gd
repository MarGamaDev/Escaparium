class_name FishTank
extends RigidBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;

@export var fish_array: Array[Node3D];

signal animation_finished;

var spawn_animation = "send_off_to_war";

func play_jump_animation() -> void:
	animation_player.play(spawn_animation);

func on_animation_finished() -> void:
	animation_finished.emit();

func reset_animation() -> void:
	animation_player.play("RESET");

func update_lives(amount: int) -> void:
	var tribute = fish_array.pick_random();
	fish_array.erase(tribute);
	tribute.queue_free();

func switch_spawn_animation(_body: Node3D) -> void:
	spawn_animation = "send_off_to_war_short";
