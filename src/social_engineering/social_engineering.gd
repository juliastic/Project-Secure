extends WindowDialog


func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$ViewportLevel.show()
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
