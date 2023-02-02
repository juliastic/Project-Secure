extends HBoxContainer

const MAX_REQUESTS := 7

var _toggle_state = {"Origin": true, "URL": true, "Role": true, "Type": true, "Count": true}
var current_key = 0

const COLUMN_CONTAINER := preload("RequestColumnContainer.tscn")

onready var incoming_requests := $IncomingScrollContainer/IncomingRequests
onready var blocked_requests := $BlockedScrollContainer/BlockedRequests


func _preload_requests() -> void:
	for request_container in get_tree().get_nodes_in_group("requests"):
		request_container.queue_free()

	for key in Requests.requests:
		if get_tree().get_nodes_in_group("incoming_requests").size() > MAX_REQUESTS - 2:
			current_key = get_tree().get_nodes_in_group("incoming_requests").size()
			return
		_load_request(key)


func _load_request(key: int) -> void:
	var request = Requests.requests[key]
	var request_instance = COLUMN_CONTAINER.instance()
	request_instance.add_constant_override("separation", 20)
	request_instance.connect("button_down", get_parent().get_parent(), "_on_Request_pressed", [str(key)])
	var i = 0
	for child in request_instance.get_node("RequestContainer").get_children():
		if not child is RichTextLabel:
			continue
		child.bbcode_text = request[i]
		i += 1
		_toggle_node(_toggle_state[child.get_name()], child)
	if not request_instance.get_node("RequestContainer").get_node("URL").text.begins_with($FilterContainer/FilterText.text):
		request_instance.hide()
	request_instance.set_name(str(key))
	request_instance.add_to_group("incoming_requests")
	request_instance.add_to_group("requests")
	incoming_requests.add_child(request_instance)


func _on_Request_toggled(id: String, block: bool) -> void:
	$Timer.stop()
	var from = incoming_requests if block else blocked_requests
	var to = blocked_requests if block else incoming_requests
	var from_group = "incoming_requests" if block else "blocked_requests"
	var to_group = "blocked_requests" if block else "incoming_requests"
	var request = from.get_node(id)
	request.remove_from_group(from_group)
	from.remove_child(request)
	request.add_to_group(to_group)
	to.add_child(request)
	$Timer.start()


func _on_Column_toggled(button_pressed: bool, key: String) -> void:
	_toggle_state[key] = button_pressed
	if button_pressed:
		incoming_requests.get_node("HBoxContainer").get_node(key).show()
		blocked_requests.get_node("HBoxContainer").get_node(key).show()
	else:
		incoming_requests.get_node("HBoxContainer").get_node(key).hide()
		blocked_requests.get_node("HBoxContainer").get_node(key).hide()
		
	var all_containers = get_tree().get_nodes_in_group("incoming_requests") + get_tree().get_nodes_in_group("blocked_requests")
	for request_container in all_containers:
		_toggle_node(button_pressed, request_container.get_node("RequestContainer").get_node(key))


func _toggle_node(toggle: bool, node: Node) -> void:
		if toggle:
			node.show()
		else:
			node.hide()


func _on_Incoming_Request() -> void:
	if Requests.blocked_requests.size() == Requests.requests.size():
		$Timer.stop()
		return
	var nodes_to_remove = get_tree().get_nodes_in_group("incoming_requests").size() - MAX_REQUESTS
	for i in nodes_to_remove:
		 get_tree().get_nodes_in_group("incoming_requests")[i].queue_free()
	while current_key in Requests.blocked_requests:
		current_key += 1
		if current_key >= Requests.requests.size():
			current_key = 0
	_load_request(current_key)
	current_key += 1
	if current_key >= Requests.requests.size():
		current_key = 0


func _on_GameStart_pressed() -> void:
	$Timer.start()


func _on_LevelFinishedNode_level_reset_triggered() -> void:
	reset_level()


func _on_RansomwareRequestMiniGame_game_finished() -> void:
	$Timer.stop()


func _on_RansomwareRequestMiniGame_hide() -> void:
	$Timer.stop()


func reset_level() -> void:
	$FilterContainer/FilterText.text = ""
	$Timer.wait_time = 1.3 if GameProgress.hardmode_enabled else 1.5
	$Timer.start()
	for value in _toggle_state.values():
		value = true
	for child in $FilterContainer.get_children():
		if child is Button:
			child.toggle_mode = true
	_preload_requests()


func _on_FilterText_text_changed(new_text: String) -> void:
	_trigger_node_filter_update(new_text)


func _trigger_node_filter_update(text: String) -> void:
	var request_nodes = get_tree().get_nodes_in_group("requests")
	if len(text.replace(" ", "")) == 0:
		for node in request_nodes:
			node.show()
		return
	for node in request_nodes:
		if node.get_node("RequestContainer").get_node("URL").text.begins_with(text):
			node.show()
		else:
			node.hide()
