extends WindowDialog

onready var network_options := $RequestOverlay/MainRequestContainer/HeaderContainer/NetworkOptionsButton
onready var header_text = $RequestOverlay/MainRequestContainer/HeaderContainer/IncomingHeaderText

func _ready() -> void:
	network_options.add_item("Internal", -1)
	network_options.add_item("External", 0)

func _on_Requests_pressed() -> void:
	$RequestOverlay.show()

func _on_Firewall_pressed() -> void:
	$FirewallOverlay.show()

func _on_HoneypotButton_pressed():
	$FirewallOverlay/HoneypotOverlay.show()


func _on_NetworkOptionsButton_item_selected(index):
	if index == 0:
		header_text.bbcode_text = "[center]Internal Requests[/center]"
	elif index == 1:
		header_text.bbcode_text = "[center]External Requests[/center]"
