extends RigidBody3D

@export var fork: RigidBody3D;
var triggered = false;

func _on_body_entered(body: Node) -> void:
	if !triggered && body.get_groups().has("tennisball"):
		fork.apply_central_impulse(basis.z * 10)
		triggered = true;
