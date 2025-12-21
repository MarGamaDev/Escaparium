class_name FishSoundMachine
extends AudioStreamPlayer3D

@export var sound_array: Array[AudioStream] = [];

var last_index: int = -1;
var rng := RandomNumberGenerator.new();

func play_random_from_array() -> void:
	var is_picking_index := true;
	var index: int;
	
	while is_picking_index:
		index = rng.randi_range(0, sound_array.size() - 1);
		is_picking_index = last_index == index;
	
	stream = sound_array[index];
	play();
