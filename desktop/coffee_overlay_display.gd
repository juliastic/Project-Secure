extends TerminalText

signal coffee_finished()

var _coffee_triggered = false
var _coffee_show = true
var _overlay_start = 0
var _current_step = 0

func _ready() -> void:
	self.hide()
	self.text = "Yeah that'd be good right now :)"

func _process(_delta) -> void:
	if _coffee_triggered:
		_toggleCoffeeOverlay(_coffee_show)

func _on_Desktop_coffee_grabbed() -> void:
	_coffee_triggered = true
	self.show()
	self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, _current_step), 1))
	_coffee_show = true
	_overlay_start = OS.get_ticks_msec()

func _toggleCoffeeOverlay(show: bool) -> void:
	var time_elapsed = OS.get_ticks_msec() - _overlay_start
	if time_elapsed % 30 < 9:
		self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, _current_step), 1))
		if show:
			_current_step += 0.05
		else:
			_current_step -= 0.05
	if time_elapsed > 1000:
		self.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1 if show else 0), 1))
		if show:
			_coffee_show = false
			_overlay_start = OS.get_ticks_msec()
		else:
			hide()
			_coffee_triggered = false
			_current_step = 1
			self.emit_signal("coffee_finished")
