extends Camera2D

signal game_lost()
signal game_won()

const SPEED = 100
var _velocity = Vector2.ZERO


func _ready():
	pass


func _process(delta) -> void:
	if self.is_visible_in_tree():
		position.x -= delta * SPEED
		$InvisibleWall/CollisionShape2D.position.x += delta * SPEED


func _on_Enemy_player_triggered_end():
	yield(get_tree().create_timer(1.0), "timeout")
	self.emit_signal("game_won")
