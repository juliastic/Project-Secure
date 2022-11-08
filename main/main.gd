extends Panel

var beam = load("res://imgs/cursor-hover.png")

func _ready():
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_POINTING_HAND)

func _on_goto_game_pressed():
	get_tree().change_scene("res://desktop/Desktop.tscn")
