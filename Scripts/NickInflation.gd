extends TextureRect

@onready var starting_size: Vector2 = size;

var inflation_speed = 0.0001;
var timer = 1;

func _process(delta: float) -> void:
	timer += delta * inflation_speed;
	size = starting_size * timer;
