extends WindowDialog

func _ready() -> void:
	pass

func _on_CheckBox_toggled(button_pressed, key) -> void:
	GameProgress.firewall_settings[key] = button_pressed
	for value in GameProgress.firewall_settings.values():
		if not value:
			return
	if GameProgress.level == GameProgress.Level.RANSOMWARE:
		GameProgress.get_current_tasks()[5][1] = true


func _on_HoneypotButton_pressed():
	$HoneypotOverlay.popup_centered()
