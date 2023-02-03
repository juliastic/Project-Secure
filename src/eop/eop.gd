extends WindowDialog


func _ready():
	pass


func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	$ViewportLevel.show()


func _on_EoPMiniGame_hide():
	$ViewportLevel/Viewport/LevelTimer.stop()
	$GameStartNode.show()
	$ViewportLevel.hide()