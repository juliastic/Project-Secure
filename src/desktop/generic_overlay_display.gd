extends RichTextLabel

signal overlay_finished(id)

func _ready() -> void:
	self.hide()

func _on_Desktop_overlay_triggered(id) -> void:
	if id == 0:
		match(GameProgress.level):
			GameProgress.Level.TUTORIAL:
				self.bbcode_text = "[center]Don't you want to work a bit first?[/center]"
			GameProgress.Level.RANSOMWARE_TRIGGER:
				self.bbcode_text = "[center]YAY, coffee ... finally[/center]"
			GameProgress.Level.RANSOMWARE:
				self.bbcode_text = "[center]Didn't you learn your lesson?[/center]"
			GameProgress.Level.DDoS:
				self.bbcode_text = "[center]Yeah go ahead ... we're only being bombared with requests! Nothing to see.[/center]"
			GameProgress.Level.SOCIAL_ENGINEERING:
				self.bbcode_text = "[center]Yeah that'd be nice ... BUT WE HAVE AN INTRUDER![/center]"
			GameProgress.Level.EoP:
				self.bbcode_text = "[center]HOW CAN YOU BE DRINKING COFFEE WHEN WE HAVE A CUP TO CATCH?![/center]"
		
		if GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER:
			GameProgress.get_current_tasks()[2][1] = true
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
