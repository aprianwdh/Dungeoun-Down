extends CanvasLayer




func _on_resume_pressed():
	get_parent().toggle_menu()


func _on_restart_pressed():
	get_parent().toggle_menu()
	#await get_tree().create_timer()
	BaseLevel.last_item()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()
