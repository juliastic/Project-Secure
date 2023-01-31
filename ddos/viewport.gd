extends Viewport

const ATTACKER_VELOCITY = 200

const ATTACKER := preload("Attacker.tscn")

var rng = RandomNumberGenerator.new()


func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	rng.randomize()
	var x_position = rng.randf_range(-680, 680)
	rng.randomize()
	var y_position = rng.randf_range(0, 200)
	var attacker = ATTACKER.instance()
	attacker.position.x = x_position
	attacker.position.y = y_position
	attacker.linear_velocity = Vector2(0, ATTACKER_VELOCITY)
	self.add_child(attacker)
