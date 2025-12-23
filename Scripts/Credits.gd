class_name Credits
extends Control

#don't mind the nick

func on_quit() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn");
