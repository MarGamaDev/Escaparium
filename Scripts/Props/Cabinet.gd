class_name Cabinet
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var interactable: Interactable = $"CABINET DOOR/AnimatableBody3D";

func on_interact() -> void:
	print("opening")
	animation_player.play("open");
	interactable.prerequisite_strings.append("already_triggered");
	
