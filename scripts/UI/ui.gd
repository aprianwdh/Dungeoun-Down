extends CanvasLayer

var current_wepon = 'knife'
var ammo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		if current_wepon == 'knife':
			$AnimatedSprite2D.play("tusuk")
		elif current_wepon == 'gun':
			if ammo > 0:
				$AnimatedSprite2D.play('shoot')
				ammo -= 0


func _on_animated_sprite_2d_animation_finished():
	if current_wepon == 'knife':
		$AnimatedSprite2D.play("iddle_knife")
	elif current_wepon == 'gun':
		$AnimatedSprite2D.play("iddle_gun")
