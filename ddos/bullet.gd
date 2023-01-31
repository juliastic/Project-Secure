extends RigidBody2D


func _on_Bullet_body_entered(body):
	print("called")
	if body is Attacker:
		body.destroy()
