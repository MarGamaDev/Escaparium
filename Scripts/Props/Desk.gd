extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var upper_shelf_snap_point: SnapPoint = $"Upper Shelf Point";
@onready var lower_shelf_snap_point: SnapPoint = $"Lower Shelf Point";
@onready var upper_fork_snap_point: SnapPoint = $"Upper Fork Point";
@onready var lower_fork_snap_point: SnapPoint = $"Lower Fork Point";

var open_drawers: int = 0;
var upper_fork: RigidBody3D;
var lower_fork: RigidBody3D;

signal set_up_ramp(flag: String);
var flag: String = "ramp";

func on_upper_fork_placed(body: Node3D) -> void:
	print("upper fork placed");
	upper_fork = (body as RigidBody3D);
	upper_fork.connect("body_entered", open_upper_drawer);

func on_lower_fork_placed(body: Node3D) -> void:
	print("lower fork placed");
	lower_fork = (body as RigidBody3D);
	lower_fork.connect("body_entered", open_lower_drawer);

func release_lower_fork() -> void:
	lower_fork.reparent(get_tree().root);
	lower_fork.grabbable = true;
	lower_fork.freeze = false;

func release_upper_fork() -> void:
	upper_fork.reparent(get_tree().root);
	upper_fork.grabbable = true;
	upper_fork.freeze = false;

func open_lower_drawer(body: Node) -> void:
	if !body is Interactable:
		return
		
	print("opening lower drawer");
	lower_fork.disconnect("body_entered", open_lower_drawer);
	animation_player.play("open_lower_drawer");

func open_upper_drawer(body: Node) -> void:
	if !body is Interactable:
		return
		
	print("opening upper drawer");
	upper_fork.disconnect("body_entered", open_upper_drawer);
	animation_player.play("open_upper_drawer");

func count_open_drawer() -> void:
	open_drawers += 1;
	if open_drawers == 2:
		lower_shelf_snap_point.snap_point_active = true;

func on_lower_shelf_placed(_body: Node3D) -> void:
	upper_shelf_snap_point.snap_point_active = true;
	lower_shelf_snap_point.snap_point_active = false;

func on_upper_shelf_placed(_body: Node3D) -> void:
	upper_shelf_snap_point.snap_point_active = false;
	set_up_ramp.emit(flag);
