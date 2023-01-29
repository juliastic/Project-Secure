extends HBoxContainer

const MAX_REQUESTS = 5

var _current_level = -1

var _active_request_containers = []
var _blocked_request_containers = []

var _toggle_state = {"Origin": true, "URL": true, "Role": true, "Type": true, "Count": true}
var current_key = 0

onready var column_container := preload("RequestColumnContainer.tscn")

func _ready() -> void:
	_preload_requests()


func _process(_delta) -> void:
	if _current_level != GameProgress.level and is_visible_in_tree():
		_current_level = GameProgress.level


func _preload_requests() -> void:
	var all_containers = _active_request_containers + _blocked_request_containers
	for request_container in all_containers:
		request_container.queue_free()
	_active_request_containers = []
	_blocked_request_containers = []

	for key in Requests.requests:
		if _active_request_containers.size() > MAX_REQUESTS - 2:
			current_key = _active_request_containers.size()
			return
		_load_request(key)

func _load_request(key: int):
	var request = Requests.requests[key]
	var request_instance = column_container.instance()
	request_instance.add_constant_override("separation", 20)
	request_instance.connect("button_down", get_parent().get_parent(), "_on_Request_pressed", [str(key)])
	var i = 0
	for child in request_instance.get_node("RequestContainer").get_children():
		child.bbcode_text = request[i]
		i += 1
		_toggle_node(_toggle_state[child.get_name()], child)
	request_instance.set_name(str(key))
	_active_request_containers.append(request_instance)
	$IncomingRequests.add_child(request_instance)


func _on_Request_toggled(id: String, block: bool) -> void:
	var from = $IncomingRequests if block else $BlockedRequests
	var to = $BlockedRequests if block else $IncomingRequests
	var request = from.get_node(id)
	from.remove_child(request)
	to.add_child(request)
	var from_containers = _active_request_containers if block else _blocked_request_containers
	var to_containers = _blocked_request_containers if block else _active_request_containers
	var index = 0
	for container in from_containers:
		if container.get_name() == id:
			from_containers.remove(index)
			to_containers.append(container)
			break
		index += 1


func _on_Column_toggled(button_pressed: bool, key: String) -> void:
	_toggle_state[key] = button_pressed
	if button_pressed:
		$IncomingRequests/HBoxContainer.get_node(key).show()
		$BlockedRequests/HBoxContainer.get_node(key).show()
	else:
		$IncomingRequests/HBoxContainer.get_node(key).hide()
		$BlockedRequests/HBoxContainer.get_node(key).hide()
		
	for request_container in _active_request_containers:
		_toggle_node(button_pressed, request_container.get_node("RequestContainer").get_node(key))


func _toggle_node(toggle: bool, node: Node) -> void:
		if toggle:
			node.show()
		else:
			node.hide()


func _on_Incoming_Request():
	if Requests.blocked_requests.size() == Requests.requests.size():
		$Timer.stop()
		return
	if _active_request_containers.size() >= MAX_REQUESTS:
		_active_request_containers[0].queue_free()
		_active_request_containers.remove(0)
	while current_key in Requests.blocked_requests:
		current_key += 1
		if current_key >= Requests.requests.size():
			current_key = 0
	_load_request(current_key)
	current_key += 1
	if current_key >= Requests.requests.size():
		current_key = 0


func _on_GameStart_pressed():
	$Timer.start()


func _on_LevelFinishedNode_level_reset_triggered():
	$Timer.start()
	_toggle_buttons(false)
	_preload_requests()


func _toggle_buttons(disable: bool) -> void:
	var all_request_containers = _active_request_containers + _blocked_request_containers
	for request_container in all_request_containers:
		request_container.disabled = disable
	$ButtonContainer/BlockButton.disabled = disable
	$ButtonContainer/UnblockButton.disabled = disable
	for child in $FilterContainer.get_children():
		child.disabled = disable


func _on_RansomwareRequestMiniGame_game_finished():
	$Timer.stop()
	_toggle_buttons(true)


func _on_RansomwareRequestMiniGame_hide():
	$Timer.stop()
