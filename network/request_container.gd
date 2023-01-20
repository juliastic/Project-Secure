extends HBoxContainer

var _current_level = GameProgress.level
var _active_requests = Requests.INCOMING_REQUESTS
var _request_containers = []

# TODO: handle deletion of rows
func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	if _current_level != GameProgress.level and GameProgress.level in _active_requests:
		_current_level = GameProgress.level
		preload_requests()
	
func preload_requests() -> void:
	for request_container in _request_containers:
		request_container.queue_free()
	_request_containers = []
	
	var requestContainer = preload("RequestColumnContainer.tscn")
	if !GameProgress.level in _active_requests:
		# remove rows here
		return
	var requests = _active_requests[GameProgress.level]

	for key in requests:
		if key in Requests.blocked_requests:
			continue
		var request = requests[key]
		var requestInstance = requestContainer.instance()
		requestInstance.connect("button_down", get_parent().get_parent().get_parent(), "_on_Request_pressed", [str(key)])
		var i = 0
		for child in requestInstance.get_node("RequestContainer").get_children():
			child.bbcode_text = request[i]
			i += 1
		requestInstance.set_name(str(key))
		_request_containers.append(requestInstance)
		$IncomingRequests.add_child(requestInstance)

func _on_Request_toggled(id: String, block: bool) -> void:
	var from = $IncomingRequests if block else $BlockedRequests
	var to = $BlockedRequests if block else $IncomingRequests
	var request = from.get_node(id)
	from.remove_child(request)
	to.add_child(request)

func _on_NetworkOptionsButton_item_selected(index):
	if index == 0:
		_active_requests = Requests.INCOMING_REQUESTS
	else:
		_active_requests = {}
	preload_requests()
