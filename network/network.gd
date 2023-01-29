extends WindowDialog

func _ready() -> void:
	pass

func _on_Requests_pressed() -> void:
	if GameProgress.level == GameProgress.Level.RANSOMWARE:
		$RansomwareRequestMiniGame.set_position(Vector2(190, 300))
		$RansomwareRequestMiniGame.show()
	elif GameProgress.level == GameProgress.Level.DDoS:
		$DDoSInvaderMiniGame.set_position(Vector2(190, 50))
		$DDoSInvaderMiniGame.show()


func _on_Firewall_pressed() -> void:
	$FirewallOverlay.show()


func _on_HoneypotButton_pressed():
	$FirewallOverlay/HoneypotOverlay.show()


func _on_Desktop_level_started():
	pass
