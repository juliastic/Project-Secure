extends WindowDialog

func _ready() -> void:
	pass

func _on_Requests_pressed() -> void:
	if GameProgress.level == GameProgress.Level.RANSOMWARE and $RansomwareRequestMiniGame.is_inside_tree():
		$RansomwareRequestMiniGame.set_position(Vector2(190, 300))
		$RansomwareRequestMiniGame.show()
	elif GameProgress.level == GameProgress.Level.DDoS and $DDoSInvaderMiniGame.is_inside_tree():
		$DDoSInvaderMiniGame.set_position(Vector2(190, 50))
		$DDoSInvaderMiniGame.show()
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and $SocialEngineeringMiniGame.is_inside_tree():
		$SocialEngineeringMiniGame.set_position(Vector2(190, 50))
		$SocialEngineeringMiniGame.show()
	self.hide()


func _on_Firewall_pressed() -> void:
	$FirewallOverlay.popup_centered()


func _on_HoneypotButton_pressed() -> void:
	$FirewallOverlay/HoneypotOverlay.popup_centered()


func _on_Desktop_level_started():
	pass
