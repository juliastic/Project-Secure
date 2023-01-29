extends Node2D

signal level_reset_triggered()

var current_game_over = false

func _ready():
	self.hide()


func _input(event) -> void:
	if event is InputEventMouse and event.is_pressed() and self.is_visible_in_tree():
		if current_game_over:
			GameProgress.reset_level()
			self.emit_signal("level_reset_triggered")
		else:
			GameProgress.complete_level()
		$AnimationPlayer.play("Fade")
		yield(get_node("AnimationPlayer"), "animation_finished")
		self.hide()


func _on_Desktop_level_finished_triggered(game_over) -> void:
	current_game_over = game_over
	$Display.bbcode_text = "[center]Sorry - try a bit harder next time :)[/center]" if game_over else str("[center]You scored ", GameProgress.level_score[GameProgress.level], "! The next challenge awaits you![/center]")
	self.show()
	$AnimationPlayer.play_backwards("Fade")
	yield(get_node("AnimationPlayer"), "animation_finished")
