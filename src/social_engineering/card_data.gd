class_name CardData
extends Resource

export(int) var id
export(int) var unique_id
export(int) var type
export(String) var description
export(bool) var open

func _init(p_id: int, p_type: int, p_description: String):
	id = p_id
	type = p_type
	description = p_description
	open = false
	unique_id = id
