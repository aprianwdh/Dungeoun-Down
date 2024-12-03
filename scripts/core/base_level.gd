extends Node3D


#var ammo : int = 20
#var current_weapon : String = 'gun'
#var last_weapon : String = 'gun'
#var health_player = 100
#var lives = 3
#var current_level = 1
#var player_score = 0


	
func last_item():
	Global.ammo = 20
	Global.current_weapon = 'gun'
	Global.health_player = 100
	Global.player_score = 0
