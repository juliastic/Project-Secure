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
		$AnimationPlayer.play("Fade")
		get_tree().paused = false
		yield(get_node("AnimationPlayer"), "animation_finished")
		self.hide()
		animation_complete = false


func _on_Desktop_level_finished_triggered(game_over) -> void:
	get_tree().paused = true
	current_game_over = game_over
	$Display.bbcode_text = "[center]Sorry - try a bit harder next time :)[/center]" if game_over else str("[center]You've scored ", GameProgress.level_score[GameProgress.level], " points! The next challenge awaits you![/center]")
	self.show()
	$AnimationPlayer.play_backwards("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
	animation_complete = true
