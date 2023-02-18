extends KinematicBody2D

signal player_triggered_end()

var _velocity = Vector2.ZERO
var end = false

const SPEED = 200

onready var wall_detector := $WallDetector
onready var sprite = $AnimatedSprite


func _physics_process(_delta) -> void:
	if not get_parent().is_visible_in_tree() or end:
		return
		
	_velocity.x = SPEED
	
	_velocity = move_and_slide(_velocity)
	
	if wall_detector.is_colliding():
		sprite.scale.x = -1
		end = true
		


func _on_Area2D_body_entered(body):
	if body is EoPPlayer:
		self.emit_signal("player_triggered_end")


func reset() -> void:
	position = Vector2(500, 303)
	sprite.scale.x = 1
	end = false
