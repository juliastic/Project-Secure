extends Node2D

signal coffee_grabbed()
signal level_started()
signal coffee_completed()

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

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$ButtonContainer.add_constant_override("separation", 50)
	var animations = [$Coffee, $MachineGun, $LevelNode]
	for animation in animations:
		animation.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	terminal_display.text = GameProgress.terminal_text

func _input(event) -> void:
	if event is InputEventKey and event.pressed and GameProgress.intro_completed and not overlay_displayed and not $Network/FirewallOverlay/HoneypotOverlay.is_visible_in_tree():
		var level = GameProgress.level
		if event.scancode == KEY_ENTER:
			if terminal_input == TerminalCommands.MIN:
				_terminalToggle()
			elif terminal_input == TerminalCommands.GRAB_COFFEE:
				_toggle_overlay_displayed(true)
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
			elif terminal_input == TerminalCommands.CAPACITY and TerminalCommands.CAPACITY in TerminalData.SUPPORTED_COMMANDS[level]:
				rng.randomize()
				GameProgress.terminal_text += str("\n", TerminalData.CAPACITY_VALUES[level][rng.randi_range(0, 2)])
				GameProgress.get_current_tasks()[9][1] = "1"
			elif terminal_input == TerminalCommands.CREATE_FIREWALL:
				_print_command(terminal_input, TerminalData.CREATE_FIREWALL_VALUES, "\nFirewall already exists.", 3)
			elif terminal_input == TerminalCommands.LISTEN_REQUESTS:
				_print_command(terminal_input, TerminalData.LISTEN_REQUESTS_VALUES, "\nAlready listening to requests.", 4)
			elif terminal_input == TerminalCommands.ENABLE_IDS:
				_print_command(terminal_input, TerminalData.ENABLE_IDS_VALUES, "\nIDS is already enabled..", 8)
			else:
				GameProgress.terminal_text += str("\nHm I somehow have yet to learn to understand what ", terminal_input, " means ...")
			GameProgress.terminal_text += str("\n", START_LINE if not overlay_displayed else "")
			terminal_display.bbcode_text = GameProgress.terminal_text
			if level == GameProgress.Level.TUTORIAL and GameProgress.get_current_tasks()[0][1] == "0" and terminal_input in TerminalCommands.COMMANDS:
				GameProgress.get_current_tasks()[0][1] = "1"
			terminal_input = ""
		elif terminal_input.length() > 0 and event.scancode == KEY_BACKSPACE or event.scancode == KEY_DELETE:
			GameProgress.terminal_text = GameProgress.terminal_text.left(GameProgress.terminal_text.length() - 1)
			terminal_input = terminal_input.left(terminal_input.length() - 1)
			terminal_display.bbcode_text = GameProgress.terminal_text
		elif event.scancode in KeyConstants.KEY_MAP && GameProgress.terminal_shown:
			var letter = KeyConstants.KEY_MAP[event.scancode]
			GameProgress.terminal_text += letter
			terminal_display.bbcode_text = GameProgress.terminal_text
			terminal_input += letter

func _print_command(command: String, data_list, terminal_text_enabled: String, task_id: int):
	if not terminal_input in TerminalData.SUPPORTED_COMMANDS[GameProgress.level]:
		return

	if GameProgress.get_current_tasks()[task_id][1] == "0":
		GameProgress.terminal_text += str("\n", data_list[GameProgress.level])
		GameProgress.get_current_tasks()[task_id][1] = "1"
	else:
		GameProgress.terminal_text += terminal_text_enabled
	GameProgress.get_current_tasks()[task_id][1] = "1"
				
func _on_NetworkButton_pressed() -> void:
	var tutorial_active = GameProgress.level == GameProgress.Level.TUTORIAL or GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER
	if GameProgress.level == GameProgress.Level.TUTORIAL:
		GameProgress.get_current_tasks()[1][1] = "1"
	var first_stage_ransomware = GameProgress.level == GameProgress.Level.RANSOMWARE and GameProgress.get_current_tasks()[3][1] == "0" and GameProgress.get_current_tasks()[3][1] == "0"
	var buttons_disabled = tutorial_active or first_stage_ransomware
	$Network/ButtonContainer/RequestOverviewButton.disabled = buttons_disabled
	$Network/ButtonContainer/FirewallOverviewButton.disabled = buttons_disabled
	if first_stage_ransomware:
		$Network/InfoText.bbcode_text = "[center]Please create a Firewall and enable Network listening in the Terminal first.[/center]"
	else:
		_toggle_node($Network/InfoText, tutorial_active)
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
		self.emit_signal("coffee_completed")
		_handle_level_switch()
		$Coffee.hide()
	else:
		terminal_display.add_text("...")
		GameProgress.terminal_text += "..."
		yield(get_tree().create_timer(1.0), "timeout")
	_toggle_overlay_displayed(false)
	#GameProgress.terminal_text += NEW_LINE
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
	_toggle_overlay_displayed(true)
	GameProgress.set_next_level()
	Requests.reset_blocked_requests()
	if GameProgress.get_level_name() == "":
		self.emit_signal("level_started")
		_toggle_overlay_displayed(false)
		return
	$LevelNode.show()
	$LevelNode/LevelTextOverlay.bbcode_text = str("[center]", GameProgress.get_level_name(), "[/center]")
	$LevelNode/AnimationPlayer.play_backwards("Fade")
	yield(get_tree().create_timer(1.5), "timeout")
	$LevelNode/AnimationPlayer.play("Fade")
	self.emit_signal("level_started")
	$Network.hide()
	$Network/RansomwareRequestMiniGame.hide()
	$Network/FirewallOverlay.hide()
	yield(get_node("LevelNode/AnimationPlayer"), "animation_finished")
	$LevelNode.hide()
	if GameProgress.level == GameProgress.Level.DDoS:
		_trigger_DDoS_start()
		return
	else:
		_toggle_overlay_displayed(false)
	yield(get_tree().create_timer(0.4), "timeout")
	_add_text_to_terminal(str("\n...\n[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]", NEW_LINE))
	
func _trigger_DDoS_start() -> void:
	_add_text_to_terminal(str("\n...\n[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]"))
	_toggle_overlay_displayed(true)
	$MachineGun.show()
	$MachineGun/AnimationPlayer.play_backwards("Fade")
	$MachineGun.playing = true
	yield(get_node("MachineGun"), "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	$MachineGun/AnimationPlayer.play("Fade")
	yield(get_node("MachineGun"), "animation_finished")
	$MachineGun.hide()
	_toggle_overlay_displayed(false)
	_add_text_to_terminal(NEW_LINE)

func _add_text_to_terminal(text: String) -> void:
	GameProgress.terminal_text += text
	terminal_display.bbcode_text = GameProgress.terminal_text

func _toggle_overlay_displayed(enable: bool) -> void:
	overlay_displayed = enable
	_toggle_menu_buttons(enable)

func _toggle_menu_buttons(disable: bool) -> void:
	$ButtonContainer/NetworkButton.disabled = disable
	$ButtonContainer/TerminalButton.disabled = disable
