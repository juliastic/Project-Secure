extends ParallaxBackground

const VELOCITY = 200

func _process(delta):
	scroll_offset.x -= VELOCITY * delta
