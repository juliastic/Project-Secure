extends ParallaxBackground

const SPEED = 200

func _process(delta) -> void:
	if get_parent().is_visible_in_tree():
		scroll_offset.x -= SPEED * delta
