extends Position2D

const BULLET := preload("Bullet.tscn")
const BULLET_VELOCITY = 1000

onready var timer = $Cooldown

func trigger_bullet(x_position: float, y_position: float) -> bool:
	if not timer.is_stopped():
		return false
	var bullet = BULLET.instance()
	bullet.position.x = x_position
	bullet.position.y = y_position
	bullet.linear_velocity = Vector2(0, -BULLET_VELOCITY)
	bullet.connect("shattered_cup", get_parent().get_parent().get_parent(), "_on_Increase_Score")
	self.add_child(bullet)
	bullet.get_node("AnimationPlayer").play("destroy")
	timer.start()
	return true
