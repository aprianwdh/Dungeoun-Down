extends CanvasLayer

var current_wepon = Global.current_weapon
var ammo = Global.ammo

var time_since_last_shoot = 0.0
var fire_rate = 1.0
var can_shoots = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('iddle_'+Global.current_weapon)



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


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play('iddle_'+Global.current_weapon)
	
func update_health():
	$Health.text = str(get_parent().player_health)
