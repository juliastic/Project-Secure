extends WindowDialog

signal game_won()
signal game_lost()


func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	$ViewportLevel.show()
	$ViewportLevel/Viewport/Level.show()


func _on_EoPMiniGame_hide():
	$GameStartNode.show()
	$ViewportLevel.hide()
	$ViewportLevel/Viewport/Level.hide()


func _on_Level_game_lost():
	self.emit_signal("game_lost")


func _on_Level_game_won():
	self.emit_signal("game_won")
