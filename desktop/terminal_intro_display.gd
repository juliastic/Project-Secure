extends TerminalText

var intro_animation_started = false
var _intro_start = 0
var _current_step = 1
var _game_step_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_append_to_intro_text()
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	if GameProgress.intro_completed:
		self.queue_free()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and !(GameProgress.intro_completed or intro_animation_started) and (event.scancode == KEY_SPACE or event.scancode == KEY_ENTER):
		if _game_step_progress < len(ConsoleDialogue.INTRO_DIALOGUE):
			_append_to_intro_text()
		else:
			$AnimationPlayer.play("Fade")
			yield(get_node("AnimationPlayer"), "animation_finished")
			GameProgress.intro_completed = true
			#_intro_start = OS.get_ticks_msec()
			#intro_animation_started = true

func _process(_delta) -> void:
	if intro_animation_started:
		_introScreenAnimation()

func _introScreenAnimation() -> void:
	var time_elapsed = OS.get_ticks_msec() - _intro_start
	if time_elapsed % 30 < 9:
		self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, _current_step), 1))
		_current_step -= 0.05
	if time_elapsed > 1000:
		self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
		GameProgress.intro_completed = true
		self.queue_free()

func _append_to_intro_text() -> void:
	self.bbcode_text += ConsoleDialogue.INTRO_DIALOGUE[_game_step_progress]
	_game_step_progress += 1
