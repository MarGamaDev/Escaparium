extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var upper_shelf_snap_point: SnapPoint = $"Upper Shelf Point"
@onready var lower_shelf_snap_point: SnapPoint = $"Lower Shelf Point"
@onready var upper_fork_snap_point: SnapPoint = $"Upper Fork Point"
@onready var lower_fork_snap_point: SnapPoint = $"Lower Fork Point"

var upper_fork: RigidBody3D;
var lower_fork: RigidBody3D;

func on_upper_fork_placed(body: Node3D) -> void:
	upper_fork_snap_point.snap_point_active = false;
	upper_fork = (body as RigidBody3D);
	upper_fork.connect("body_entered", open_lower_drawer);

func on_lower_fork_placed(body: Node3D) -> void:
	lower_fork_snap_point.snap_point_active = false;
	lower_fork = (body as RigidBody3D);
	lower_fork.connect("body_entered", open_upper_drawer);

func release_lower_fork() -> void:
	lower_fork.reparent(SceneTree.root);
	lower_fork.freeze = false;

func release_upper_fork() -> void:
	upper_fork.reparent(SceneTree.root);
	upper_fork.freeze = false;

func open_lower_drawer(_body: Node3D) -> void:
	lower_fork.disconnect("body_entered", open_lower_drawer);
	animation_player.play("open_lower_drawer");

func open_upper_drawer(_body: Node3D) -> void:
	upper_fork.disconnect("body_entered", open_upper_drawer);
	animation_player.play("open_upper_drawer");

func activate_upper_shelf_snap_point() -> void:
	pass
	
func activate_lower_shelf_snap_point() -> void:
	pass

func on_lower_shelf_placed(_body: Node3D) -> void:
	upper_shelf_snap_point.snap_point_active = true;
	lower_shelf_snap_point.snap_point_active = false;
	pass

func on_upper_shelf_placed(_body: Node3D) -> void:
	# something something change global preqs
	pass
