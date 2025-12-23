class_name EndScreen
extends Control

@export var textures: Array[Texture2D];
@export var time_between_frames: float = 0.5;

@onready var target: TextureRect = $TextureRect;

var index: int = 0;
var timer: float = 0;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED;

func _process(delta: float) -> void:
	timer += delta;
	
	if timer >= time_between_frames:
		index += 1;
		index %= textures.size();
		target.texture = textures[index];
		timer = 0;
	

func on_quit() -> void:
	get_tree().quit();

func on_new_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn");
