extends Node2D

signal level_reset_triggered()

var current_game_over = false
var animation_complete = false

func _ready() -> void:
	self.hide()
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))


func _input(event) -> void:
	if not event is InputEventMouse or not event.is_pressed() or not animation_complete:
		return
	if current_game_over:
		GameProgress.reset_level()
		self.emit_signal("level_reset_triggered")
	else:
		GameProgress.complete_level()
		var network = get_parent().get_node("Network")
		network.hide()
		if GameProgress.level == GameProgress.Level.RANSOMWARE:
			network.get_node("RansomwareRequestMiniGame").queue_free()
		elif GameProgress.level == GameProgress.Level.DDoS:
			network.get_node("DDoSInvaderMiniGame").queue_free()
		elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
			network.get_node("SocialEngineeringMiniGame").queue_free()
		elif GameProgress.level == GameProgress.Level.EoP:
			OS.shell_open("https://pads.c3w.at/form/#/2/form/view/YnUksqmPnvPJ-STTnNqTM3A+uvkrbq24ZbCQQ0Iucq8/")
			GameProgress.reset_game()
			get_tree().paused = false
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
			$Display.bbcode_text = "[center]\nTHANK YOU SO MUCH!\nYou've saved our system!\n\nPress anywhere to be forwarded to the evaluation and return to the main menu.[/center]"
			$BrokenCup.show()
		elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
			$Display.bbcode_text = str("[center]\nYou've scored ", GameProgress.level_score[GameProgress.level], " points!\nMore importantly: We finally know what the attacker is up to.\nFIND THEM!!![/center]")
		elif GameProgress.level == GameProgress.Level.RANSOMWARE:
			$Display.bbcode_text = str("[center]\nYou've scored ", GameProgress.level_score[GameProgress.level], " points!\nInteresting things that are going on in the honeypot ...[/center]")
		elif GameProgress.level == GameProgress.Level.DDoS:
			$Display.bbcode_text = str("[center]\nYou've scored ", GameProgress.level_score[GameProgress.level], " points!\nYou showed these cups! But wait ...[/center]")
	self.show()
	$AnimationPlayer.play_backwards("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
	if GameProgress.level == GameProgress.Level.EoP:
		$BrokenCup.play()
		yield(get_node("BrokenCup"), "animation_finished")
	animation_complete = true
