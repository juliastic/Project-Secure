extends ParallaxBackground

const VELOCITY = 200

func _process(delta):
	#if get_parent().get_parent().is_visible_in_tree():
	scroll_offset.x -= VELOCITY * delta
