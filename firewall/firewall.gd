extends WindowDialog

func _ready() -> void:
	pass

func _on_CheckBox_toggled(button_pressed, key) -> void:
	GameProgress.firewall_settings[key] = button_pressed
	for value in GameProgress.firewall_settings.values():
		if not value:
			return
	if GameProgress.level == GameProgress.Level.RANSOMWARE:
		GameProgress.get_current_tasks()[3][1] = "1"
