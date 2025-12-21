class_name Interactable
extends Node3D

@export var prerequisite_strings: Array[String] = [];
signal interact_triggered;

func _interact() -> void:
	interact_triggered.emit();

func can_interact(prerequisites: Array[String]) -> bool:
	print("trying to interact");
	for item in prerequisite_strings:
		if !prerequisites.has(item):
			print("doesn't satisfy: ", item)
			return false
	print("pull the lever kronk")
	return true;
