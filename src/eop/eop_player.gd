extends KinematicBody2D

var _velocity = Vector2.ZERO

const PLAYER_SPEED = Vector2(150.0, 350.0)

onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite


func _physics_process(delta) -> void:
	if not get_parent().is_visible_in_tree():
		return

	var viewport_game := get_viewport().get_visible_rect()
	
	var snap_vector = Vector2.ZERO
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("ui_accept") and _velocity.y < 0.0
	print(_velocity)
	_velocity = calculate_move_velocity(_velocity, direction, PLAYER_SPEED, is_jump_interrupted)

	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * 20.0

	_velocity.x = PLAYER_SPEED.x * direction.x

	_velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector2.UP, true, 4, 0.9, false)
	
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
	
	_velocity.y += gravity * delta
	if _velocity.y > 0:
		_velocity += Vector2.DOWN * gravity * 5 * delta
	elif _velocity.y < 0 and is_jump_interrupted:
		_velocity += Vector2.DOWN * gravity * 0.8 * delta


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("ui_accept") else 0
	)

func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

func get_new_animation(is_shooting = false) -> String:
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new
