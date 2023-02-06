extends WindowDialog

signal game_won()
signal game_lost()

func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$ViewportLevel.show()
	$ViewportLevel/Viewport.reset_level()
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()


func _on_SocialEngineeringMiniGame_hide():
	$ViewportLevel/Viewport/LevelTimer.stop()
	$GameStartNode.show()
	$ViewportLevel.hide()

