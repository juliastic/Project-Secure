extends KinematicBody2D

var _velocity = Vector2.ZERO

const SPEED = 300


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	var viewport_game := get_viewport().get_visible_rect()
	var sprite_width = $AnimatedSprite.get_sprite_frames().get_frame("default", 2).get_width()
	if Input.is_action_pressed("move_left") and position.x > -viewport_game.end.x / 2 + sprite_width / 6:
		_velocity.x = -1 * SPEED
		_velocity = move_and_slide(_velocity, Vector2.LEFT)
	elif Input.is_action_pressed("move_right") and position.x < viewport_game.end.x / 2 - sprite_width / 3:
		_velocity.x = SPEED
		_velocity = move_and_slide(_velocity, Vector2.RIGHT)
	if Input.is_action_pressed("ui_accept"):
		$AnimatedSprite.playing = true
		var sprite_dimensions = $AnimatedSprite.get_sprite_frames().get_frame("default", 2)
		var bullet_y = position.y - sprite_dimensions.get_height() / 2 - 25
		$AnimatedSprite/BulletPosition.trigger_bullet(0, bullet_y)
	elif Input.is_action_just_released("ui_accept"):
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
