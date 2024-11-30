extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.03

@onready var ui = $UI
@onready var ray= $Camera3D/RayCast3D
#var player_health = Global.health_player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("kiri", "kanan", "depan", "belakang")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_pressed('ui_left'):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed('ui_right'):
		self.rotate_y(-TURN_SPEED)
		
	if Input.is_action_pressed("ui_accept"):
		if ui.can_shoots == true:
			shoot()

	move_and_slide()
	
func shoot():
	if ray.is_colliding() and ray.get_collider().has_method("die"):
		ray.get_collider().die()
		
func take_damage():
	Global.health_player -= 5
	if Global.health_player <= 0:
		queue_free()
		
