extends WindowDialog

func _ready() -> void:
	pass # Replace with function body.

func _on_CheckBox_toggled(button_pressed, key) -> void:
	GameProgress.firewall_settings[key] = button_pressed
	print(GameProgress.firewall_settings)
