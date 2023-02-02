extends AnimatedSprite


func flip_card(open: bool) -> void:
	self.play("default", not open)
	if open:
		$Description/AnimationPlayer.play("Fade")
	else:
		$Description/AnimationPlayer.play_backwards("Fade")
