extends WindowDialog

signal game_won()
signal game_lost()

onready var level := $ViewportLevel/Viewport/Level

func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	$ViewportLevel.show()
	level.show()


func _on_EoPMiniGame_hide(): 
	$GameStartNode.show()
	$ViewportLevel.hide()
	level.hide()
	level.reset_level()


func _on_Level_game_lost():
	self.emit_signal("game_lost")


func _on_Level_game_won():
	self.emit_signal("game_won")

func _on_LevelFinishedNode_level_reset_triggered() -> void:
	if GameProgress.level != GameProgress.Level.EoP:
		return
	level.reset_level()
