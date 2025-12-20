class_name PlayerController
extends CharacterBody3D

@export var horizontalSpeed: float = 1;
@export var sprintMultiplier: float = 2;
@export var flopForce: float = 1;
@export var jumpForce: float = 2;
@export var airControlMultiplier: float = 0.1;
var inputVector := Vector2.ZERO;
var isSprinting := false;
var isGrounded := false;

func _process(delta: float) -> void:
	take_input()
	check_ground()
	apply_movement()

func take_input() -> void:
	var x: int = 0;
	var y: int = 0;
	
	if Input.is_action_pressed("Move_Left"):
		x -= 1;
	if Input.is_action_pressed("Move_Right"):
		x += 1;
	if Input.is_action_pressed("Move_Forward"):
		y += 1;
	if Input.is_action_pressed("Move_Back"):
		y += 1;
	
	inputVector.x = x;
	inputVector.y = y;
	
	isSprinting = Input.is_action_pressed("Sprint");

func check_ground() -> void:
	return

func apply_movement() -> void:
	return
