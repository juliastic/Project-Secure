extends WindowDialog

signal request_toggled(id)

onready var network_options := $RequestOverlay/MainRequestContainer/HeaderContainer/NetworkOptionsButton
onready var header_text = $RequestOverlay/MainRequestContainer/HeaderContainer/IncomingHeaderText

var pressed_request_id = "-1"

func _ready() -> void:
	network_options.add_item("Internal", -1)
	network_options.add_item("External", 0)
	network_options.add_item("Honeypot", 0)
	self.connect("request_toggled", $RequestOverlay/MainRequestContainer/RequestContainer, "_on_Request_toggled")

func _process(delta):
	if GameProgress.level == GameProgress.Level.RANSOMWARE and GameProgress.get_current_tasks()[3][1] == "1" and GameProgress.get_current_tasks()[4][1]:
		$RequestOverlay/SetupIncompleteText.hide()
		$RequestOverlay/MainRequestContainer.show()

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
	elif index == 2:
		header_text.bbcode_text = "[center]Honeypot Requests[/center]"

func _on_Request_pressed(id: String) -> void:
	pressed_request_id = id

func _on_LineButton_button_down(block: bool) -> void:
	if pressed_request_id == "-1":
		return
	var blocked_requests = Requests.blocked_requests
	if block:
		blocked_requests.append(pressed_request_id)
	else:
		for index in blocked_requests.size():
			if blocked_requests[index] == pressed_request_id:
				blocked_requests.remove(index)
				break
	self.emit_signal("request_toggled", pressed_request_id, block)
	pressed_request_id = "-1"
