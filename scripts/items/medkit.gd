extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player") and Global.health_player < 100:
		Global.health_player = min(Global.health_player + 10,100)
		AudioManager.medkit_soune()
		queue_free()
