extends HBoxContainer

var _current_level = GameProgress.level

func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	if _current_level != GameProgress.level and GameProgress.level in Requests.INCOMING_REQUESTS:
		_current_level = GameProgress.level
		preload_requests()
	
func preload_requests() -> void:
	var requestContainer = preload("RequestColumnContainer.tscn")
	var requests = Requests.INCOMING_REQUESTS[GameProgress.level]
	for request in requests.values():
		var requestInstance = requestContainer.instance()
		var i = 0
		for child in requestInstance.get_children():
			child.bbcode_text = request[i]
			i += 1
		$IncomingRequests.add_child(requestInstance)


func _on_NetworkOptionsButton_item_selected(index):
	# handle switch here
	
	pass # Replace with function body.
