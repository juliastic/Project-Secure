extends RigidBody2D

signal shattered_cup()

func _on_Bullet_body_entered(body):
	if body is Attacker:
		self.emit_signal("shattered_cup")
		body.destroy()
	$AnimatedSprite.play("shattered")
	yield(get_tree().create_timer(0.1), "timeout")
	self.queue_free()
