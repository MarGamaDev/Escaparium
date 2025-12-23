class_name GlassShard
extends RigidBody3D

var rng := RandomNumberGenerator.new();

func _on_window_shatter_glass(origin: Vector3, force: float, lifetime: float) -> void:
	freeze = false;
	var impulse: Vector3 = -(origin - global_position).normalized() * force;
	apply_central_impulse(impulse);
	apply_torque_impulse(force * Vector3(rng.randf_range(1, 5), rng.randf_range(1, 5), rng.randf_range(1, 5)));
	disappear_after_lifetime(lifetime);

func disappear_after_lifetime(lifetime: float) -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free();
