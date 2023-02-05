extends Camera2D

var _velocity = Vector2.ZERO

const SPEED = 100


func _ready():
	pass


func _process(delta) -> void:
	position.x -= delta * SPEED
	pass
