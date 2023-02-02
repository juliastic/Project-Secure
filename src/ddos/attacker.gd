class_name Attacker
extends RigidBody2D


func _ready() -> void:
	$AnimationPlayer.play("destroy_delay")


func destroy() -> void:
	$AnimatedSprite.playing = true
	yield(get_node("AnimatedSprite"), "animation_finished")
	self.queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "destroy_delay":
		self.queue_free()
