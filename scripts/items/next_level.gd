extends Area3D

@export var next_Level : PackedScene


func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.current_level = 2
		get_tree().change_scene_to_packed(next_Level)
