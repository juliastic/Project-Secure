extends WindowDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#func _on_NetworkNode_pressed(description_key: String) -> void:
#	$NetworkOverlay/Description.text = NodeDescriptions.NODE_DESCRIPTION_MAP[description_key]
#	network_overlay.show(

func _on_Requests_pressed():
	$RequestOverlay.show()
