extends Panel

func _init() -> void:
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://imgs/cursor-sample.png"), Input.CURSOR_POINTING_HAND)

func _on_GameButton_pressed() -> void:
	if get_tree().change_scene("res://desktop/Desktop.tscn") != OK:
		print("Couldn't switch to scene Desktop Scene")
