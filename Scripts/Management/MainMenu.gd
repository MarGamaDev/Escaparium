class_name MainMenu
extends Control


func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn");

func on_quit() -> void:
	get_tree().quit();

func on_credits() -> void:
	pass
