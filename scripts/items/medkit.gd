extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.health_player = min(Global.health_player + 10,100)
		queue_free()
