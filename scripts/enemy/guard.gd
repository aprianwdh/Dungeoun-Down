extends  CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 10
var chase_palayer = false
var guard_health = 100

func _ready():
	add_to_group("Enemy")
	
func _physics_process(delta):
	if dead or is_attacking:
		return

	if player == null:
		return

	var dist_to_player = global_position.distance_to(player.global_position)

	# Hanya bergerak jika pemain dalam jangkauan tertentu
	if dist_to_player <= attack_range * 2: # Ganti dengan jarak yang diinginkan
		chase_palayer = true
	else:
		chase_palayer = false

	if chase_palayer:
		var dir = player.global_position - global_position
		dir.y = 0.0
		dir = dir.normalized()

		#$AnimatedSprite3D.play("default")
		velocity = dir * SPEED

		if not is_on_floor():
			velocity.y -= gravity * delta

		look_at(player.global_position)
		move_and_slide()
		attack()

	
func attack():
	#if chase_palayer == true:
		var dist_to_player = global_position.distance_to(player.global_position)
		if dist_to_player > attack_range:
			$AnimatedSprite3D.play("deafult")

		#if chase_palayer == true:
		else:
			is_attacking = true
			AudioManager.gun_enemy_sound()
			$AnimatedSprite3D.play("shoot")
			if $RayCast3D.is_colliding() and $RayCast3D.get_collider().has_method("take_damage"):
				$RayCast3D.get_collider().take_damage()
			await $AnimatedSprite3D.animation_finished
			is_attacking = false
			
		
func die():
	dead = true
	Global.player_score += 10
	AudioManager.guard_die_sound()
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
	
func take_damage_enemy():
	AudioManager.guard_die_sound()
	match Global.current_weapon:
		'gun':
			guard_health -= 15
		'knife':
			guard_health -= 10
		'mini':
			guard_health -= 20
		'machine':
			guard_health -= 25
	print(guard_health)
	if guard_health <= 0:
		die()
		



