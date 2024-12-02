extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.current_weapon = 'machine'
		Global.last_weapon = 'machine'
		AudioManager.pickup_sound()
		Global.ammo += 10
		queue_free()

