class_name DeadFish
extends Node3D

@onready var sound_player: SmartSoundArrayPlayer = $"../SmartSoundArrayPlayer";

func do_dying_thing() -> void:
	sound_player.play_random_from_array();
