extends RichTextLabel

signal overlay_finished(id)

func _ready() -> void:
	self.hide()

func _on_Desktop_overlay_triggered(id) -> void:
	if id == 0:
		if GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER:
			self.bbcode_text = "[center]YAY, coffee - finally[/center]"
			GameProgress.get_current_tasks()[2][1] = "1"
		else:
			self.bbcode_text = "[center]Yeah that'd be good right now :)[/center]"
	elif id == 1:
		self.bbcode_text = "[center]You've done it :o[/center]"
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	self.show()
	$AnimationPlayer.play_backwards("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$AnimationPlayer.play("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	self.hide()
	self.emit_signal("overlay_finished", id)
