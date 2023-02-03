extends Viewport

signal game_won()
signal game_lost()

const ATTACKER_VELOCITY = 200

const ATTACKER := preload("Attacker.tscn")

var time = 20
var system_health = 100

func _on_LevelTimer_timeout() -> void:
	time -= 1
	$GameInformationContainer/Time.bbcode_text = str("Time: ", time)
	if time == 0:
		$CupSpawnTimer.stop()
		$LevelTimer.stop()
		self.emit_signal("game_won")


func _on_Increase_Score() -> void:
	GameProgress.level_score[GameProgress.level] += 5
	$GameInformationContainer/Score.bbcode_text = str("Points: ", GameProgress.level_score[GameProgress.level])


func _on_CupSpawnTimer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x_position = rng.randf_range(100, 1400)
	rng.randomize()
	var y_position = rng.randf_range(0, 50)
	var attacker = ATTACKER.instance()
	attacker.position.x = x_position
	attacker.position.y = y_position
	attacker.linear_velocity = Vector2(0, ATTACKER_VELOCITY)
	attacker.get_node("AnimationPlayer").connect("animation_finished", self, "_on_Cup_Timeout")
	self.add_child(attacker)


func _on_LevelFinishedNode_level_reset_triggered() -> void:
	reset_level()


func _on_Cup_Timeout(_anim_name: String) -> void:
	system_health -= 10
	$GameInformationContainer/SystemHealth.bbcode_text = str("[right]System Health: ", system_health, "[/right]")
	if system_health <= 0:
		self.emit_signal("game_lost")


func reset_level() -> void:
	if GameProgress.level != GameProgress.Level.DDoS:
		return
	var attackers = get_tree().get_nodes_in_group("attackers")
	for attacker in attackers:
		attacker.queue_free()
	$CupSpawnTimer.wait_time = 1.0 if GameProgress.hardmode_enabled else 1.2
	$CupSpawnTimer.start()
	$LevelTimer.start()
	time = 20
	system_health = 100
	$GameInformationContainer/SystemHealth.bbcode_text = str("[right]System Health: ", system_health, "[/right]")
	$Player.position = Vector2(0, 0)
