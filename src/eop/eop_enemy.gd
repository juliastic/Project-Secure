extends Area2D

signal player_triggered_end()

func _ready():
	pass


func _on_Enemy_body_entered(body):
	if body is EoPPlayer:
		self.emit_signal("player_triggered_end")
		$AnimatedSprite.play("final")
