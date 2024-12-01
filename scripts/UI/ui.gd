extends CanvasLayer

var current_wepon = Global.current_weapon
var ammo = Global.ammo

var time_since_last_shoot = 0.0
var fire_rate = 1.0
var can_shoots = true
var texture_weapon = {
	'gun' : preload('res://assets/weapons/hudgun.png'),
	'mini' : preload('res://assets/weapons/hudmachinegun.png'),
	'machine' : preload('res://assets/weapons/hudmini.png'),
	'knife' : preload('res://assets/weapons/hudknife.png'),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('iddle_'+Global.current_weapon)
	update_weapon_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shoot += delta
	can_shoots = time_since_last_shoot >= (1.0/fire_rate)
	
	if Global.current_weapon != 'knife' and Global.ammo <=0 :
		Global.current_weapon = 'knife'
		$AnimatedSprite2D.play("iddle_knife")
		
	if Input.is_action_pressed('ui_accept') and can_shoots:
		if Global.current_weapon == 'knife':
			$AnimatedSprite2D.play("tusuk")
		else :
			$AnimatedSprite2D.play('shoot_'+Global.current_weapon)
			
		time_since_last_shoot = 0.0
		
		if Global.current_weapon != 'knife':
			if Global.ammo > 0:
				Global.ammo -= 1
				
	match Global.current_weapon:
		'gun':
			fire_rate = 3.0
		'machine':
			fire_rate = 6.0
		'mini':
			fire_rate = 10.0
		'knife':
			fire_rate = 2.0
		_:
			fire_rate = 1.0
			
	update_health()
	update_ammo_label()
	update_lives_label()
	update_face(Global.health_player)
	update_levels_lebel()
	update_score_label()
	update_weapon_texture()


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play('iddle_'+Global.current_weapon)
	
func update_health():
	$Health.text = str(Global.health_player)

func update_ammo_label():
	$Ammo.text = str(Global.ammo)
	
func update_lives_label():
	$Lives.text = str(Global.lives)
	
func update_face(health):
	var animated_face = ''
	if health > 90:
		animated_face = '90'
	elif health > 80:
		animated_face = '80'
	elif health > 70:
		animated_face = '70'
	elif health > 60:
		animated_face = '60'
	elif health > 50:
		animated_face = '50'
	elif health > 40:
		animated_face = '40'
		
	$FACE.play(animated_face)
	
func update_levels_lebel():
	$Level.text = str(Global.current_level)
	
func update_score_label():
	$Score.text = str(Global.player_score)
	
func update_weapon_texture():
	if $WEAPON.texture != texture_weapon[Global.current_weapon]:
		$WEAPON.texture = texture_weapon[Global.current_weapon]
