extends WindowDialog

var honeypot_settings = GameProgress.honeypot_settings.duplicate(true)


func _ready():
	_handle_save_button()


func _on_CheckBox_toggled(button_pressed, key):
	honeypot_settings[key] = button_pressed


func _on_HoneypotSaveButton_pressed():
	honeypot_settings["file_name"] = $CheckboxContainer/Filename.text
	if honeypot_settings.hash() != GameProgress.honeypot_settings.hash():
		GameProgress.honeypot_settings = honeypot_settings

	if GameProgress.level == GameProgress.Level.RANSOMWARE and honeypot_settings["attack_information"] and honeypot_settings["accessed_data"]:
		GameProgress.get_current_tasks()[6][1] = true


func _on_Filename_text_changed(new_text: String) -> void:
	_handle_save_button(new_text)


func _handle_save_button(text: String = "") -> void:
	$CheckboxContainer/HoneypotSaveButton.disabled = len(text.replace(" ", "")) == 0
