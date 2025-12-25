class_name MainMenu
extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED;

func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn");

func on_quit() -> void:
	get_tree().quit();

func on_credits() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn");
