extends Node2D

signal coffee_grabbed()
signal level_started()

onready var terminal_animation_player = $AnimationNode/TerminalAnimationPlayer
onready var terminal_display = $AnimationNode/TerminalAnimationPlayer/TerminalDisplay
onready var coffee_overlay_display = $OverlayNode/CoffeeOverlayDisplay
onready var network_window = $Network

var task_completion_sound := preload("res://sounds/task_completed.mp3")

const START_LINE = ">> "
const NEW_LINE = str("\n", START_LINE)
var terminal_input = ""
var overlay_displayed = false
var _current_coffee_fade_step = 0
var _current_level_overlay_fade_step = 0
var _trigger_coffee = true
var _trigger_level_overlay = true

func _ready() -> void:
	$Coffee.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	$LevelNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	terminal_display.text = GameProgress.terminal_text

func _input(event) -> void:
	if event is InputEventKey and event.pressed and GameProgress.intro_completed and not overlay_displayed:
		var level = GameProgress.level
		if event.scancode == KEY_ENTER:
			if terminal_input == TerminalCommands.MIN:
				_terminalToggle()
			elif terminal_input == TerminalCommands.GRAB_COFFEE:
				overlay_displayed = true
				self.emit_signal("coffee_grabbed")
			elif terminal_input == TerminalCommands.HELP:
				GameProgress.terminal_text += str("\n", TerminalData.generate_help_text(level))
			elif terminal_input.begins_with(TerminalCommands.EXPLAIN):
				var term_to_explain = terminal_input.replace(str(TerminalCommands.EXPLAIN, " "), "")
				if term_to_explain in TerminalData.EXPLAIN_VALUES[level]:
					GameProgress.terminal_text += str("\n", TerminalData.EXPLAIN_VALUES[level][term_to_explain])
				else:
					GameProgress.terminal_text += str("\nSorry I don't know [i]", term_to_explain, "[/i] ...")
			elif terminal_input == TerminalCommands.LIST_TERMS:
				GameProgress.terminal_text += TerminalData.generate_list_terms(level)
			elif terminal_input == TerminalCommands.BACKSTORY:
				GameProgress.terminal_text += str("\n", TerminalData.BACKSTORY_VALUES[level])
			else:
				GameProgress.terminal_text += str("\nHm I somehow have yet to learn to understand what ", terminal_input, " means ...")
			GameProgress.terminal_text += str("\n", START_LINE if not overlay_displayed else "")
			terminal_display.bbcode_text = GameProgress.terminal_text
			terminal_input = ""
			if level == GameProgress.Level.TUTORIAL and GameProgress.get_current_tasks()[0][1] == "0":
				GameProgress.get_current_tasks()[0][1] = "1"
		elif terminal_input.length() > 0 and event.scancode == KEY_BACKSPACE or event.scancode == KEY_DELETE:
			GameProgress.terminal_text = GameProgress.terminal_text.left(GameProgress.terminal_text.length() - 1)
			terminal_input = terminal_input.left(terminal_input.length() - 1)
			terminal_display.bbcode_text = GameProgress.terminal_text
		elif event.scancode in KeyConstants.KEY_MAP && GameProgress.terminal_shown:
			var letter = KeyConstants.KEY_MAP[event.scancode]
			GameProgress.terminal_text += letter
			terminal_display.bbcode_text = GameProgress.terminal_text
			terminal_input += letter

func _on_NetworkButton_pressed() -> void:
	var tutorial_active = GameProgress.level == GameProgress.Level.TUTORIAL or GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER
	if GameProgress.level == GameProgress.Level.TUTORIAL:
		GameProgress.get_current_tasks()[1][1] = "1"
	_toggle_node(network_window.get_node("ButtonContainer/RequestOverviewButton"), not tutorial_active)
	_toggle_node(network_window.get_node("ButtonContainer/ComputerOverviewButton"), not tutorial_active)
	_toggle_node(network_window.get_node("ButtonContainer/FirewallOverviewButton"), not tutorial_active)
	_toggle_node(network_window.get_node("TutorialText"), tutorial_active)
	network_window.show()

func _toggle_node(node: Node, show: bool) -> void:
	if show:
		node.show()
	else:
		node.hide()

func _on_Network_hide() -> void:
	pass

func _on_TerminalButton_pressed() -> void:
	_terminalToggle()

func _on_CoffeeOverlayDisplay_coffee_finished() -> void:
	if GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER:
		terminal_display.add_text("...\n")
		$Coffee.show()
		$Coffee/AnimationPlayer.play_backwards("Fade")
		$Coffee.playing = true
		yield(get_node("Coffee"), "animation_finished")
		terminal_display.add_text("...\n")
		yield(get_tree().create_timer(1.0), "timeout")
		terminal_display.add_text("...\n")
		yield(get_tree().create_timer(1.0), "timeout")
		GameProgress.terminal_text += ConsoleDialogue.CONSOLE_DIALOGUE["levels"][2]["GRAB COFFEE"]
		terminal_display.bbcode_text = GameProgress.terminal_text
		yield(get_tree().create_timer(1.0), "timeout")
		$Coffee.playing = false
		$Coffee/AnimationPlayer.play("Fade")
		_handle_level_switch()
		$Coffee.hide()
	else:
		terminal_display.add_text("...")
		GameProgress.terminal_text += "..."
		yield(get_tree().create_timer(1.0), "timeout")
	overlay_displayed = false
	GameProgress.terminal_text += NEW_LINE
	terminal_display.bbcode_text = GameProgress.terminal_text

func _terminalToggle() -> void:
	terminal_animation_player.play("MinimiseTerminal" if GameProgress.terminal_shown else "ShowTerminal")
	GameProgress.terminal_shown = !GameProgress.terminal_shown

func _on_TaskContainer_level_completed():
	_handle_level_switch()

func _on_TaskContainer_task_completed():
	if !$AudioPlayer.is_playing():
		$AudioPlayer.stream = task_completion_sound
		$AudioPlayer.play()

func _handle_level_switch() -> void:
	GameProgress.set_next_level()
	if GameProgress.get_level_name() == "":
		self.emit_signal("level_started")
		return
	$LevelNode.show()
	$LevelNode/LevelTextOverlay.bbcode_text = str("[center]", GameProgress.get_level_name(), "[/center]")
	$LevelNode/AnimationPlayer.play_backwards("Fade")
	yield(get_tree().create_timer(1.5), "timeout")
	$LevelNode/AnimationPlayer.play("Fade")
	self.emit_signal("level_started")
	yield(get_node("LevelNode/AnimationPlayer"), "animation_finished")
	$LevelNode.hide()
