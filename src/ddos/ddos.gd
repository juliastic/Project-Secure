extends WindowDialog

signal game_won()
signal game_lost()

func _on_GameStart_pressed() -> void:
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	$ViewportLevel.show()
	$ViewportLevel/Viewport.reset_level()


func _on_DDoSInvaderMiniGame_hide():
	$ViewportLevel/Viewport/CupSpawnTimer.stop()
	$ViewportLevel/Viewport/LevelTimer.stop()
	$GameStartNode.show()
	$ViewportLevel.hide()


func _on_Viewport_game_lost():
	self.emit_signal("game_lost")


func _on_Viewport_game_won():
	self.emit_signal("game_won")


func _on_LevelFinishedNode_level_reset_triggered() -> void:
	if GameProgress.level != GameProgress.Level.DDoS:
		return
	$ViewportLevel/Viewport.reset_level()
