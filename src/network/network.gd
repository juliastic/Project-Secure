extends WindowDialog

onready var firewall_button := $ButtonContainer/FirewallOverviewButton
onready var activity_button := $ButtonContainer/RequestOverviewButton


func _process(_delta) -> void:
	if firewall_button.disabled or activity_button.disabled:
		var tutorial_active = GameProgress.level == GameProgress.Level.TUTORIAL or GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER
		var current_tasks = GameProgress.get_current_tasks()
		var first_stage_ransomware = GameProgress.level == GameProgress.Level.RANSOMWARE and (current_tasks[3][1] == "0" or current_tasks[4][1] == "0")
		var first_stage_ddos = GameProgress.level == GameProgress.Level.DDoS and (GameProgress.get_current_tasks()[8][1] == "0" or current_tasks[9][1] == "0")
		var first_stage_social_engineering = GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and current_tasks[11][1] == "0"
		var first_stage_eop = GameProgress.level == GameProgress.Level.EoP and current_tasks[13][1] == "0"
		var first_stage_active = tutorial_active or first_stage_ransomware or first_stage_social_engineering or first_stage_ddos or first_stage_eop
		activity_button.disabled = first_stage_active
		firewall_button.disabled = GameProgress.level != GameProgress.Level.RANSOMWARE or first_stage_ransomware
		if not activity_button.disabled:
			$InfoText.hide()


func _on_Requests_pressed() -> void:
	if GameProgress.level == GameProgress.Level.RANSOMWARE and $RansomwareRequestMiniGame.is_inside_tree():
		var first_stage =  GameProgress.get_current_tasks()[5][1] == "0" or  GameProgress.get_current_tasks()[6][1] == "0"
		$RansomwareRequestMiniGame/GameStartNode.call("hide" if first_stage else "show")
		$RansomwareRequestMiniGame/InfoText.call("show" if first_stage else "hide")
		$RansomwareRequestMiniGame.set_position(Vector2(190, 300))
		$RansomwareRequestMiniGame.show()
	elif GameProgress.level == GameProgress.Level.DDoS and $DDoSInvaderMiniGame.is_inside_tree():
		$DDoSInvaderMiniGame.set_position(Vector2(190, 50))
		$DDoSInvaderMiniGame.show()
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and $SocialEngineeringMiniGame.is_inside_tree():
		$SocialEngineeringMiniGame.set_position(Vector2(190, 50))
		$SocialEngineeringMiniGame.show()
	elif GameProgress.level == GameProgress.Level.EoP and $EoPMiniGame.is_inside_tree():
		$EoPMiniGame.set_position(Vector2(190, 50))
		$EoPMiniGame.show()
	self.hide()


func _on_Firewall_pressed() -> void:
	$FirewallOverlay.popup_centered()


func _on_Desktop_level_started():
	pass # shouldn't be necessary as this popup is always closed on level switch
