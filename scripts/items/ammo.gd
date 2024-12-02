extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.ammo += 10
		Global.current_weapon = Global.last_weapon
		AudioManager.pickup_sound()
		queue_free()
