extends TerminalText

var intro_animation_started = false
var _intro_start = 0
var _current_step = 1
var _game_step_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = ">> Hello ... nice to see you. I'm guessing this is your first day? \n"
	if GameProgress.intro_completed:
		self.queue_free()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and !GameProgress.intro_completed and event.scancode == KEY_SPACE:
		if _game_step_progress == 0:
			self.text += "\n>> Either way: I'm Bob, your new partner."
			_game_step_progress += 1
		elif _game_step_progress == 1:
			_intro_start = OS.get_ticks_msec()
			intro_animation_started = true

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
