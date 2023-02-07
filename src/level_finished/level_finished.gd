extends Node2D

signal level_reset_triggered()

var current_game_over = false
var animation_complete = false

func _ready():
	self.hide()
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))


func _input(event) -> void:
	if event is InputEventMouse and event.is_pressed() and animation_complete:
		if current_game_over:
			GameProgress.reset_level()
			self.emit_signal("level_reset_triggered")
		else:
			GameProgress.complete_level()
			var network = get_parent().get_node("Network")
			get_parent().get_node("Network").hide()
			if GameProgress.level == GameProgress.Level.RANSOMWARE:
				network.get_node("RansomwareRequestMiniGame").queue_free()
			elif GameProgress.level == GameProgress.Level.DDoS:
				network.get_node("DDoSInvaderMiniGame").queue_free()
			elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
				network.get_node("SocialEngineeringMiniGame").queue_free()
			elif GameProgress.level == GameProgress.Level.EoP:
				GameProgress.reset_game()
				if get_tree().change_scene("res://src/main/Main.tscn") != OK:
					print("Couldn't switch to scene Main Scene")
				return
		$AnimationPlayer.play("Fade")
		get_tree().paused = false
		yield(get_node("AnimationPlayer"), "animation_finished")
		self.hide()
		animation_complete = false


func _on_Desktop_level_finished_triggered(game_over) -> void:
	get_tree().paused = true
	current_game_over = game_over
	if game_over:
		$Display.bbcode_text = "[center]Sorry - try a bit harder next time :)[/center]"
	else:
		if GameProgress.level == GameProgress.Level.EoP:
			$Display.bbcode_text = "[center]THANK YOU SO MUCH!\nYou've saved our system![/center]"
			$BrokenCup.show()
		elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
			$Display.bbcode_text = str("[center]You've scored ", GameProgress.level_score[GameProgress.level], " points!\nMore importantly: We finally know what the attacker is up to. FIND THEM[/center]")
		else:
			$Display.bbcode_text = str("[center]You've scored ", GameProgress.level_score[GameProgress.level], " points! The next challenge awaits you![/center]")
	self.show()
	$AnimationPlayer.play_backwards("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
	if GameProgress.level == GameProgress.Level.EoP:
		$BrokenCup.play()
		yield(get_node("BrokenCup"), "animation_finished")
	animation_complete = true
