extends Button

export(int) var id
export(String) var unique_id

func _ready() -> void:
	add_constant_override("separation", 20)
