extends Camera2D

signal game_lost()
signal game_won()

const SPEED = 100

var _velocity = Vector2.ZERO

onready var invisible_wall := $InvisibleWall/CollisionShape2D
onready var wall_of_death := $InvisibleWall/CollisionShape2D

func _process(delta) -> void:
	if self.is_visible_in_tree():
		position.x -= delta * SPEED
		invisible_wall.position.x += delta * SPEED
		wall_of_death.position.x += delta * SPEED


func _on_Enemy_player_triggered_end():
	yield(get_tree().create_timer(1.0), "timeout")
	self.emit_signal("game_won")


func _on_WallOfDeath_body_entered(body) -> void:
	if body is EoPPlayer:
		self.emit_signal("game_lost")


func reset_level() -> void:
	position = Vector2(0, 0)
	invisible_wall.position = Vector2(31, 346)
	wall_of_death.position = Vector2(0, 0)
	$Player.reset()
	$EnemyPlayer.reset()
