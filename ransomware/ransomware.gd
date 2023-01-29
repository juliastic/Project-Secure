extends WindowDialog

signal request_toggled(id, block)
signal game_lost()
signal game_won()

var _pressed_request_id = "-1"

func _ready() -> void:
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.show()
	$MainRequestContainer.hide()


func _process(_delta) -> void:
	pass


func _on_Request_pressed(id: String) -> void:
	_pressed_request_id = id


func _on_LineButton_button_down(block: bool) -> void:
	if _pressed_request_id == "-1":
		return
	_update_progress_label()
	if block:
		Requests.blocked_requests.append(_pressed_request_id)
		if Requests.blocked_requests == Requests.malicious_requests:
			GameProgress.get_current_tasks()[7][1] = "1"
			self.emit_signal("game_won")
			$Timer.stop()
			self.hide()
	else:
		for index in Requests.blocked_requests.size():
			if Requests.blocked_requests[index] == _pressed_request_id:
				Requests.blocked_requests.remove(index)
				break
	self.emit_signal("request_toggled", _pressed_request_id, block)
	_pressed_request_id = "-1"


func _toggle_info_text() -> void:
	var setup_complete = GameProgress.level != GameProgress.Level.RANSOMWARE or GameProgress.get_current_tasks()[5][1] == "1" and GameProgress.get_current_tasks()[6][1] == "1"
	var hide_info_text = setup_complete
	if hide_info_text:
		$InfoText.hide()
		$MainRequestContainer/RequestContainer.show()
	else:
		$InfoText.bbcode_text = "[center]No entries found for this request type. Happy days.[/center]"
		$InfoText.show()
		$MainRequestContainer/RequestContainer.hide()

func _update_progress_label() -> void:
	var correct_requests = 0
	for request_id in Requests.blocked_requests:
		if request_id in Requests.malicious_requests:
			correct_requests += 1
	var incorrect_requests = Requests.blocked_requests.size() - correct_requests
	$MainRequestContainer/HeaderContainer/ProgressLabel.bbcode_text = str("[color=black]", correct_requests, "/", Requests.malicious_requests.size(), " Found || ", incorrect_requests, " Requests misidentified[/color]")


func _on_Desktop_level_started():
	_toggle_info_text()


func _on_Score_update():
	GameProgress.level_score[GameProgress.level] -= 5
	$MainRequestContainer/HeaderContainer/ScoreLabel.bbcode_text = str("[right]Points: ", GameProgress.level_score[GameProgress.level], "[/right]")
	if GameProgress.level_score[GameProgress.level] == 0:
		self.emit_signal("game_lost")
		$Timer.stop()


func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$MainRequestContainer.show()
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	$Timer.start()


func _on_LevelFinishedNode_level_reset_triggered():
	Requests.blocked_requests = []
	$MainRequestContainer/HeaderContainer/ProgressLabel.bbcode_text = str("[color=black]", 0, "/", Requests.malicious_requests.size(), " Found || ", 0, " Requests misidentified[/color]")
	$MainRequestContainer/HeaderContainer/ScoreLabel.bbcode_text = str("[right]Points: ", GameProgress.level_score[GameProgress.level], "[/right]")
	$Timer.start()


func _on_RansomwareRequestMiniGame_hide():
	$Timer.stop()
