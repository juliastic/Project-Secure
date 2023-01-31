class_name Attacker
extends RigidBody2D


func _ready() -> void:
	pass


func destroy() -> void:
	$AnimatedSprite.playing = true
	yield(get_node("AnimatedSprite"), "animation_finished")
	self.queue_free()
