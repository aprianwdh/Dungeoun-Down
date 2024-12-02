extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.03
var knife_range = 3
var sensitivity = 0.2  # Sesuaikan kecepatan gerakan mouse

@onready var ui = $UI
@onready var ray = $Camera3D/RayCast3D
@onready var camera = $Camera3D  # Pastikan node kamera benar

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_open_door = false
func _ready():
	add_to_group("Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Menyembunyikan dan mengunci kursor

func _physics_process(delta):
	# Tambahkan gravitasi.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Gerakkan pemain berdasarkan input arah.
	var input_dir = Input.get_vector("kiri", "kanan", "depan", "belakang")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Putar pemain dengan tombol.
	if Input.is_action_pressed('ui_left'):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed('ui_right'):
		self.rotate_y(-TURN_SPEED)

	# Menembak jika diizinkan.
	if Input.is_action_pressed("ui_accept"):
		if ui.can_shoots == true:
			shoot()

	move_and_slide()

func shoot():
	var audio_stream_player = $AudioStreamPlayer
	match Global.current_weapon:
		'gun':
			AudioManager.gun_sound()
		'mini':
			AudioManager.mini_sound()
		'machine':
			AudioManager.machine_sound()
		'knife':
			AudioManager.knife()

	if ray.is_colliding():
		var collider = ray.get_collider()
		var distance_to_colider = global_position.distance_to(collider.global_position)

		if Global.current_weapon == 'knife' and distance_to_colider > knife_range:
			return
		else:
			if collider.has_method("take_damage_enemy"):
				collider.take_damage_enemy()

func take_damage():
	Global.health_player -= 5
	if Global.health_player <= 0:
		queue_free()

func _input(event):
	if event is InputEventMouseMotion:
		# Putar pemain berdasarkan gerakan mouse
		rotate_y(-event.relative.x * sensitivity * 0.01)
		
		# Batasi rotasi kamera
		camera.rotate_x(-event.relative.y * sensitivity * 0.01)
		var camera_rotation = camera.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -80, 80)  # Batasi ke atas dan bawah
		camera.rotation_degrees = camera_rotation
