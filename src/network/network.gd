extends WindowDialog

onready var firewall_button := $ButtonContainer/FirewallOverviewButton
onready var activity_button := $ButtonContainer/RequestOverviewButton

var _current_level = GameProgress.level

func _process(_delta) -> void:
	if not firewall_button.disabled and not activity_button.disabled and _current_level == GameProgress.level:
		return
	_current_level = GameProgress.level
	var tutorial_active = GameProgress.level == GameProgress.Level.TUTORIAL or GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER
	var current_tasks = GameProgress.get_current_tasks()
	var first_stage_ransomware = GameProgress.level == GameProgress.Level.RANSOMWARE and (not current_tasks[3][1] or not current_tasks[4][1])
	var first_stage_ddos = GameProgress.level == GameProgress.Level.DDoS and not(current_tasks[8][1] and current_tasks[9][1])
	var first_stage_social_engineering = GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and not current_tasks[11][1]
	var first_stage_eop = GameProgress.level == GameProgress.Level.EoP and not current_tasks[13][1]
	var first_stage_active = tutorial_active or first_stage_ransomware or first_stage_social_engineering or first_stage_ddos or first_stage_eop
	activity_button.disabled = first_stage_active
	firewall_button.disabled = GameProgress.level != GameProgress.Level.RANSOMWARE or first_stage_ransomware
	if not activity_button.disabled:
		$InfoText.hide()


func _on_Requests_pressed() -> void:
	if GameProgress.level == GameProgress.Level.RANSOMWARE and $RansomwareRequestMiniGame != null:
		var current_tasks = GameProgress.get_current_tasks()
		var first_stage = not current_tasks[5][1] or not current_tasks[6][1]
		$RansomwareRequestMiniGame/GameStartNode.call("hide" if first_stage else "show")
		$RansomwareRequestMiniGame/InfoText.call("show" if first_stage else "hide")
		$RansomwareRequestMiniGame.set_position(Vector2(190, 300))
		$RansomwareRequestMiniGame.show()
	elif GameProgress.level == GameProgress.Level.DDoS and $DDoSInvaderMiniGame != null:
		$DDoSInvaderMiniGame.set_position(Vector2(190, 50))
		$DDoSInvaderMiniGame.show()
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and $SocialEngineeringMiniGame != null:
		$SocialEngineeringMiniGame.set_position(Vector2(190, 50))
		$SocialEngineeringMiniGame.show()
	elif GameProgress.level == GameProgress.Level.EoP and $EoPMiniGame != null:
		$EoPMiniGame.set_position(Vector2(190, 50))
		$EoPMiniGame.show()
	self.hide()


func _on_Firewall_pressed() -> void:
	$FirewallOverlay.popup_centered()


func _on_Desktop_level_started():
	pass # shouldn't be necessary as this popup is always closed on level switch
