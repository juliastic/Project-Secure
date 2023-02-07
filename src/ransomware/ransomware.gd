extends WindowDialog

signal request_toggled(request)
signal game_lost()
signal game_won()

var _pressed_request = null

onready var progress_label := $MainRequestContainer/HeaderContainer/ProgressLabel
onready var score_label := $MainRequestContainer/HeaderContainer/ScoreLabel


func _ready() -> void:
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.show()
	$MainRequestContainer.hide()


func _on_Request_pressed(request: RequestColumnContainer) -> void:
	_pressed_request = request
	var in_incoming_requests = request.is_in_group("incoming_requests")
	_toggle_line_buttons(not in_incoming_requests, in_incoming_requests)


func _on_LineButton_button_down(block: bool) -> void:
	if _pressed_request == null:
		return
	$MainRequestContainer/RequestContainer/Timer.stop()
	if block:
		Requests.blocked_requests.append(_pressed_request)
		self._check_game_won()
	else:
		for index in Requests.blocked_requests.size():
			if Requests.blocked_requests[index].request_data.unique_id == _pressed_request.request_data.unique_id:
				Requests.blocked_requests.remove(index)
				break
		self._check_game_won()
	self._update_progress_label()
	self._toggle_line_buttons(false, false)
	self.emit_signal("request_toggled", _pressed_request)
	_pressed_request = null
	$MainRequestContainer/RequestContainer/Timer.start()


func _check_game_won() -> void:
	if Requests.blocked_requests.size() == Requests.MALICIOUS_REQUESTS.size():
		for request in Requests.blocked_requests:
			if not request.request_data.id in Requests.MALICIOUS_REQUESTS:
				return
		GameProgress.get_current_tasks()[7][1] = "1"
		self.emit_signal("game_won")
		$ScoreTimer.stop()


func _update_progress_label() -> void:
	var correct_requests = 0
	for request in Requests.blocked_requests:
		if request.request_data.id in Requests.MALICIOUS_REQUESTS:
			correct_requests += 1
	var incorrect_requests = Requests.blocked_requests.size() - correct_requests
	progress_label.bbcode_text = str("[color=black]", correct_requests, "/", Requests.MALICIOUS_REQUESTS.size(), " Found || ", incorrect_requests, " Requests misidentified[/color]")


func _on_Score_update():
	GameProgress.level_score[GameProgress.level] -= 5
	score_label.bbcode_text = str("[right]Points: ", GameProgress.level_score[GameProgress.level], "[/right]")
	if GameProgress.level_score[GameProgress.level] == 0:
		self.emit_signal("game_lost")
		$ScoreTimer.stop()


func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$MainRequestContainer.show()
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
	self.reset_level()
	$MainRequestContainer/RequestContainer.reset_level()


func _on_LevelFinishedNode_level_reset_triggered() -> void:
	if GameProgress.level != GameProgress.Level.RANSOMWARE:
		return
	self.reset_level()
	$MainRequestContainer/RequestContainer.reset_level()


func _on_RansomwareRequestMiniGame_hide():
	$ScoreTimer.stop()
	$GameStartNode.show()
	$MainRequestContainer.hide()


func reset_level() -> void:
	GameProgress.reset_level()
	progress_label.bbcode_text = str("[color=black]", 0, "/", Requests.MALICIOUS_REQUESTS.size(), " Found || ", 0, " Requests misidentified[/color]")
	score_label.bbcode_text = str("[right]Points: ", GameProgress.level_score[GameProgress.level], "[/right]")
	$ScoreTimer.wait_time = 0.9 if GameProgress.hardmode_enabled else 1.0
	$ScoreTimer.start()
	_pressed_request = null


func _toggle_line_buttons(enable_unblock: bool, enable_block: bool) -> void:
	var button_container = $MainRequestContainer/RequestContainer/ButtonContainer
	button_container.get_node("UnblockButton").disabled = not enable_unblock
	button_container.get_node("BlockButton").disabled = not enable_block
