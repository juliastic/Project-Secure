extends HBoxContainer

var _current_level = GameProgress.level
var _active_requests = Requests.INTERNAL_REQUESTS
var _request_containers = []
var _active_request_display = Requests.Type.INTERNAL

onready var container := preload("RequestColumnContainer.tscn")

func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	if _current_level != GameProgress.level:
		_current_level = GameProgress.level
		_preload_requests()
	
func _preload_requests() -> void:
	for request_container in _request_containers:
		request_container.queue_free()
	_request_containers = []
	
	if !GameProgress.level in _active_requests:
		return
	
	var requests = _active_requests[GameProgress.level]
	for key in requests:
		var request = requests[key]
		var request_instance = container.instance()
		request_instance.add_constant_override("separation", 10)
		request_instance.connect("button_down", get_parent().get_parent().get_parent(), "_on_Request_pressed", [str(key)])
		var i = 0
		for child in request_instance.get_node("RequestContainer").get_children():
			child.bbcode_text = request[i]
			i += 1
		request_instance.set_name(str(key))
		_request_containers.append(request_instance)
		var parent = $BlockedRequests if key in Requests.blocked_requests[_active_request_display] else $IncomingRequests
		parent.add_child(request_instance)

func _on_Request_toggled(id: String, block: bool) -> void:
	var from = $IncomingRequests if block else $BlockedRequests
	var to = $BlockedRequests if block else $IncomingRequests
	var request = from.get_node(id)
	from.remove_child(request)
	to.add_child(request)

func _on_NetworkOptionsButton_item_selected(index):
	_active_request_display = index
	if _active_request_display == Requests.Type.ALL:
		_active_requests = Requests.ALL_REQUESTS
	elif _active_request_display == Requests.Type.INTERNAL:
		_active_requests = Requests.INTERNAL_REQUESTS
	elif _active_request_display == Requests.Type.EXTERNAL:
		_active_requests = Requests.EXTERNAL_REQUESTS
	elif _active_request_display == Requests.Type.HONEYPOT:
		_active_requests = Requests.HONEYPOT_REQUESTS
	_preload_requests()
