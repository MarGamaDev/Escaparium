class_name MainMenu
extends Control


func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn");
