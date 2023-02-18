class_name EoPPlayer
extends KinematicBody2D

var _velocity = Vector2.ZERO
var player_triggered_end = false

const PLAYER_SPEED = Vector2(250.0, 200.0)
const SCALE = 0.208

onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite


func _physics_process(delta) -> void:
	if not get_parent().is_visible_in_tree():
		return
	
	var snap_vector = Vector2.ZERO
	var direction = Vector2.ZERO

	if not player_triggered_end:
		direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("ui_accept") and _velocity.y < 0.0
	_velocity = self.calculate_move_velocity(_velocity, direction, PLAYER_SPEED, is_jump_interrupted)

	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * 10.0
	
	if direction.x != 0 and not $AnimatedSprite.playing:
		$AnimatedSprite.play()
	elif direction.x == 0:
		$AnimatedSprite.stop()

	_velocity.x = PLAYER_SPEED.x * direction.x

	_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector2.UP, true, 4, 0.9, false)
	
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = SCALE
		else:
			sprite.scale.x = -SCALE
	
	_velocity.y += gravity * delta
	if _velocity.y > 0:
		_velocity += Vector2.DOWN * gravity * 10 * delta
	elif _velocity.y < 0 and is_jump_interrupted:
		_velocity += Vector2.DOWN * gravity * 0.8 * delta


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("ui_accept") else 0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= 0.7
	return velocity


func _on_Enemy_player_triggered_end():
	$AnimatedSprite.stop()
	player_triggered_end = true


func reset() -> void:
	position = Vector2(190, 670)
	sprite.scale.x = SCALE
	player_triggered_end = false
