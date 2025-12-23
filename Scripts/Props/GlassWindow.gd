class_name GlassWindow
extends Node3D

@onready var glass_pane: Node3D = $"WindowAndFrame/window frame/window";
@onready var shards_parent: Node3D = $Shards;
@onready var shatter_origin: Node3D = $"Shatter Origin";

@export var shatter_force: float = 5;
@export var shard_lifetime: float = 5;

signal shatter_glass(origin: Vector3, force: float, lifetime:float);
signal raise_window_flag(flag: String);

func shatter() -> void:
	glass_pane.visible = false;
	shards_parent.visible = true;
	shatter_glass.emit(shatter_origin.global_position, shatter_force, shard_lifetime);
	raise_window_flag.emit("window")
