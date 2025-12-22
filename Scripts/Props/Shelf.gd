class_name Shelf
extends RigidBody3D

@onready var audio_player: SmartSoundArrayPlayer = $"Screwdriver Player";

@export var hinge_count: int = 2;
var current_hinges;

func _on_hinge_unscrewed() -> void:
	audio_player.play_random_from_array();
	
	hinge_count -= 1;
	if hinge_count == 0:
		freeze = false;
