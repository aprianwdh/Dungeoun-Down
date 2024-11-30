extends  CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 10
var chase_palayer = false

func _ready():
	add_to_group("Enemy")
	
func _physics_process(delta):
	if dead or is_attacking:
		return
		
	if player == null:
		return
		
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	if chase_palayer == true:
		$AnimatedSprite3D.play("deafult")
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

		if chase_palayer == true:
			is_attacking = true
			$AnimatedSprite3D.play("shoot")
			if $RayCast3D.is_colliding() and $RayCast3D.get_collider().has_method("take_damage"):
				$RayCast3D.get_collider().take_damage()
			await $AnimatedSprite3D.animation_finished
			is_attacking = false
			
		
func die():
	dead = true
	Global.player_score += 10
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
		


func _on_chase_area_body_entered(body):
	if body.has_method("take_damage"):
		#$AnimatedSprite3D.play("deafult")
		chase_palayer = true


func _on_chase_area_body_exited(body):
	if body.has_method("take_damage"):
		chase_palayer = false
