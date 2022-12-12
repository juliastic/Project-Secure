extends Node2D

signal coffee_grabbed()

onready var terminal_animation_player = $AnimationNode/TerminalAnimationPlayer
onready var terminal_display = $AnimationNode/TerminalAnimationPlayer/TerminalDisplay
onready var coffee_overlay_display = $OverlayNode/CoffeeOverlayDisplay
onready var network_window = $Network

const START_LINE = ">> "
const NEW_LINE = str("\n", START_LINE)
var terminal_input = ""
var overlay_displayed = false

func _ready() -> void:
	terminal_display.text = GameProgress.terminal_text

func _input(event) -> void:
	if event is InputEventKey and event.pressed and GameProgress.intro_completed and not overlay_displayed:
		if event.scancode == KEY_ENTER:
			if terminal_input == TerminalCommands.MIN:
				_terminalToggle()
			elif terminal_input == TerminalCommands.GRAB_COFFEE:
				overlay_displayed = true
				emit_signal("coffee_grabbed")
			else:
				GameProgress.terminal_text += "\nCommand not known..."
			GameProgress.terminal_text += str("\n", START_LINE if not overlay_displayed else "")
			terminal_display.bbcode_text = GameProgress.terminal_text
			terminal_input = ""
			if GameProgress.level == GameProgress.Level.RANSOMWARE && GameProgress.get_current_tasks()[0][1] == "0":
				GameProgress.get_current_tasks()[0][1] = "1"
				print(GameProgress.get_current_tasks())
		elif terminal_input.length() > 0 and event.scancode == KEY_BACKSPACE or event.scancode == KEY_DELETE:
			GameProgress.terminal_text = GameProgress.terminal_text.left(GameProgress.terminal_text.length() - 1)
			terminal_input = terminal_input.left(terminal_input.length() - 1)
			terminal_display.bbcode_text = GameProgress.terminal_text
		elif event.scancode in KeyConstants.KEY_MAP && GameProgress.terminal_shown:
			var letter = KeyConstants.KEY_MAP[event.scancode]
			GameProgress.terminal_text += letter
			terminal_display.bbcode_text = GameProgress.terminal_text
			terminal_input += letter

func _process(_delta) -> void:
	pass

func _on_NetworkButton_pressed() -> void:
	network_window.show()
	overlay_displayed = true

func _on_Network_hide():
	overlay_displayed = false

func _on_TerminalButton_pressed() -> void:
	_terminalToggle()

func _on_CoffeeOverlayDisplay_coffee_finished():
	terminal_display.add_text("...\n")
	yield(get_tree().create_timer(1.0), "timeout")
	terminal_display.add_text("...\n")
	yield(get_tree().create_timer(1.0), "timeout")
	overlay_displayed = false
	GameProgress.terminal_text += "...\n...\n[i]You've found a USB stick ... oh no ... you've plugged it in - cuddle move[/i]"
	terminal_display.bbcode_text = GameProgress.terminal_text
	yield(get_tree().create_timer(1.0), "timeout")
	GameProgress.terminal_text += NEW_LINE
	terminal_display.bbcode_text = GameProgress.terminal_text
	
func _terminalToggle():
	terminal_animation_player.play("MinimiseTerminal" if GameProgress.terminal_shown else "ShowTerminal")
	GameProgress.terminal_shown = !GameProgress.terminal_shown
