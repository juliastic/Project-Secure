extends Panel

onready var animation_player := $TransitionRect/AnimationPlayer

func _init() -> void:
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/imgs/cursor-sample.png"), Input.CURSOR_POINTING_HAND)

func _on_GameButton_pressed() -> void:
	$TransitionRect.show()
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	if get_tree().change_scene("res://src/desktop/Desktop.tscn") != OK:
		print("Couldn't switch to scene Desktop Scene")


func _on_Main_tree_entered():
	$TransitionRect/AnimationPlayer.play("Fade")
	yield($TransitionRect/AnimationPlayer, "animation_finished")
	$TransitionRect.hide()
