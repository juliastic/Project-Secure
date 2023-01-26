extends WindowDialog

signal request_toggled(id)

onready var network_options := $RansomwareRequestMiniGame/MainRequestContainer/HeaderContainer/Filter/NetworkOptionsButton
onready var header_text = $RansomwareRequestMiniGame/MainRequestContainer/HeaderContainer/IncomingHeaderText

var _pressed_request_id = "-1"
var _active_request_display = 0

func _ready() -> void:
	network_options.add_item("All", -1)
	network_options.add_item("Internal", 0)
	network_options.add_item("External", 1)
	network_options.add_item("Honeypot", 2)
	self.connect("request_toggled", $RansomwareRequestMiniGame/MainRequestContainer/RequestContainer, "_on_Request_toggled")
	$RansomwareRequestMiniGame/InfoText.show()

func _process(delta):
	if GameProgress.level == GameProgress.Level.RANSOMWARE and GameProgress.get_current_tasks()[5][1] == "1" and GameProgress.get_current_tasks()[6][1] == "1" and not $RansomwareRequestMiniGame/MainRequestContainer.is_visible_in_tree():
		$RansomwareRequestMiniGame/MainRequestContainer.show()
		_toggle_info_text()

func _on_Requests_pressed() -> void:
	$RansomwareRequestMiniGame.show()

func _on_Firewall_pressed() -> void:
	$FirewallOverlay.show()

func _on_HoneypotButton_pressed():
	$FirewallOverlay/HoneypotOverlay.show()

func _on_NetworkOptionsButton_item_selected(index):
	_active_request_display = index
	_toggle_info_text()
	if _active_request_display == Requests.Type.ALL:
		header_text.bbcode_text = "All Requests"
	elif _active_request_display == Requests.Type.INTERNAL:
		header_text.bbcode_text = "Internal Requests"
	elif _active_request_display == Requests.Type.EXTERNAL:
		header_text.bbcode_text = "External Requests"
	elif _active_request_display == Requests.Type.HONEYPOT:
		header_text.bbcode_text = "Honeypot Requests"

func _on_Request_pressed(id: String) -> void:
	_pressed_request_id = id

func _on_LineButton_button_down(block: bool) -> void:
	if _pressed_request_id == "-1":
		return
	var blocked_requests = Requests.blocked_requests[_active_request_display]
	if block:
		blocked_requests.append(_pressed_request_id)
		if _active_request_display == Requests.Type.HONEYPOT and GameProgress.level == GameProgress.Level.RANSOMWARE and _pressed_request_id == "5":
			GameProgress.get_current_tasks()[7][1] = "1"
	else:
		for index in blocked_requests.size():
			if blocked_requests[index] == _pressed_request_id:
				blocked_requests.remove(index)
				break
	self.emit_signal("request_toggled", _pressed_request_id, block)
	_pressed_request_id = "-1"
	
func _toggle_info_text() -> void:
	var setup_complete = GameProgress.level != GameProgress.Level.RANSOMWARE or GameProgress.get_current_tasks()[5][1] == "1" and GameProgress.get_current_tasks()[6][1] == "1"
	var hide_info_text = setup_complete and GameProgress.level in Requests.REQUESTS[_active_request_display] and Requests.REQUESTS[_active_request_display][GameProgress.level].size() > 0
	if hide_info_text:
		$RansomwareRequestMiniGame/InfoText.hide()
		$RansomwareRequestMiniGame/MainRequestContainer/RequestContainer.show()
	else:
		$RansomwareRequestMiniGame/InfoText.bbcode_text = "[center]No entries found for this request type. Happy days.[/center]"
		$RansomwareRequestMiniGame/InfoText.show()
		$RansomwareRequestMiniGame/MainRequestContainer/RequestContainer.hide()

func _on_Desktop_level_started():
	_toggle_info_text()
