class_name RequestData
extends Resource

export(String) var id
export(String) var unique_id

func _init(p_id: String, p_unique_id: String) -> void:
	id = p_id
	unique_id = p_unique_id
