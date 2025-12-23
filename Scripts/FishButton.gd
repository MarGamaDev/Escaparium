class_name FishButton
extends TextureButton

@export var bob_speed: float = 1;
@export var bob_intensity: float = 1;

@onready var start_position = position;

var timer = 0;

func _process(delta: float) -> void:
	timer += delta * bob_speed;
	var offset: float = sin(timer) * bob_intensity;
	position = start_position + (offset * Vector2.UP);
