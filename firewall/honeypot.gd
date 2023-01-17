extends WindowDialog

var honeypot_settings = GameProgress.honeypot_settings.duplicate(true)

func _on_CheckBox_toggled(button_pressed, key):
	honeypot_settings[key] = button_pressed

func _on_HoneypotSaveButton_pressed():
	honeypot_settings["file_name"] = $CheckboxContainer/Filename.text
	if honeypot_settings.hash() != GameProgress.honeypot_settings.hash():
		GameProgress.honeypot_settings = honeypot_settings
