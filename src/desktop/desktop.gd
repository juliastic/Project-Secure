extends Node2D

signal overlay_triggered(id)
signal level_started()
signal coffee_completed()
signal level_finished_triggered(game_over)

onready var terminal_animation_player = $TerminalDisplay/TerminalAnimationPlayer
onready var terminal_display = $TerminalDisplay
onready var network_window = $Network

var task_completion_sound := preload("res://sounds/task_completed.mp3")
var background_computer_img := preload("res://assets/background_computer.png")

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
	$BackgroundTexture.texture = background_computer_img
	$BackgroundTexture.expand = true
	$ButtonContainer.add_constant_override("separation", 50)
	var animations = [$Coffee, $MachineGun, $LevelNode]
	for animation in animations:
		animation.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	terminal_display.text = GameProgress.terminal_text


func _input(event) -> void:
	var not_key_event = not event is InputEventKey or not event.is_pressed()
	if overlay_displayed or $Network/FirewallOverlay/HoneypotOverlay.is_visible_in_tree() or not GameProgress.intro_completed or not_key_event:
		return
	var level = GameProgress.level
	if event.scancode == KEY_ENTER:
		if terminal_input == TerminalCommands.MIN:
			_terminal_toggle()
		elif terminal_input == TerminalCommands.GRAB_COFFEE:
			_toggle_overlay_displayed(true)
			self.emit_signal("overlay_triggered", 0)
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
		elif terminal_input == TerminalCommands.TOGGLE_HARDMODE and TerminalCommands.TOGGLE_HARDMODE in TerminalData.SUPPORTED_COMMANDS[level]:
			GameProgress.hardmode_enabled = !GameProgress.hardmode_enabled
			GameProgress.terminal_text += str("\nHardmode", " enabled" if GameProgress.hardmode_enabled else " disabled", ".")
		elif terminal_input == TerminalCommands.CREATE_FIREWALL:
			_print_command(terminal_input, TerminalData.CREATE_FIREWALL_VALUES, "\nFirewall already exists.", 3)
		elif terminal_input == TerminalCommands.LISTEN_REQUESTS:
			_print_command(terminal_input, TerminalData.LISTEN_REQUESTS_VALUES, "\nAlready listening to requests.", 4)
		elif terminal_input == TerminalCommands.ENABLE_IDS:
			_print_command(terminal_input, TerminalData.ENABLE_IDS_VALUES, "\nIDS is already enabled..", 8)
		else:
			GameProgress.terminal_text += str("\nHm I somehow have yet to learn what [i]", terminal_input, "[/i] means. Sorry about that ...")
		_add_text_to_terminal(str("\n", START_LINE if not overlay_displayed else ""))
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
	if not command in TerminalData.SUPPORTED_COMMANDS[GameProgress.level]:
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
	var first_stage_ransomware = GameProgress.level == GameProgress.Level.RANSOMWARE and (GameProgress.get_current_tasks()[3][1] == "0" or GameProgress.get_current_tasks()[4][1] == "0")
	var buttons_disabled = tutorial_active or first_stage_ransomware
	$Network/ButtonContainer/RequestOverviewButton.disabled = buttons_disabled
	$Network/ButtonContainer/FirewallOverviewButton.disabled = buttons_disabled
	if first_stage_ransomware:
		$Network/InfoText.bbcode_text = "[center]Please create a Firewall and enable Network listening in the Terminal first.[/center]"
	_toggle_node($Network/InfoText, tutorial_active or first_stage_ransomware)
	#network_window.set_position(Vector2(650, 400))
	#network_window.show()
	network_window.popup_centered()

func _toggle_node(node: Node, show: bool) -> void:
	if show:
		node.show()
	else:
		node.hide()


func _on_Network_hide() -> void:
	pass


func _on_TerminalButton_pressed() -> void:
	_terminal_toggle()


func _terminal_toggle() -> void:
	GameProgress.terminal_shown = !GameProgress.terminal_shown
	if GameProgress.terminal_shown:
		terminal_display.show()
		terminal_animation_player.play_backwards("MinimiseTerminal")
	else:
		terminal_animation_player.play("MinimiseTerminal")
	yield(terminal_animation_player, "animation_finished")


func _on_TaskContainer_level_completed():
	_handle_level_switch()


func _on_TaskContainer_task_completed():
	if !$AudioPlayer.is_playing():
		$AudioPlayer.stream = task_completion_sound
		$AudioPlayer.play()


func _handle_level_switch() -> void:
	_toggle_overlay_displayed(true)
	GameProgress.set_next_level()
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
	yield(get_node("LevelNode/AnimationPlayer"), "animation_finished")
	$LevelNode.hide()
	if GameProgress.level == GameProgress.Level.DDoS or GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
		_trigger_level_start()
		return
	else:
		_toggle_overlay_displayed(false)
	yield(get_tree().create_timer(0.4), "timeout")
	_add_text_to_terminal(str("\n...\n[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]", NEW_LINE))


func _trigger_level_start() -> void:
	var animated_sprite = null
	if GameProgress.level == GameProgress.Level.DDoS:
		animated_sprite = $MachineGun
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
		animated_sprite = $Disguise

	if animated_sprite == null:
		return
		
	_add_text_to_terminal(str("\n...\n[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]"))
	_toggle_overlay_displayed(true)
	animated_sprite.show()
	animated_sprite.get_node("AnimationPlayer").play_backwards("Fade")
	animated_sprite.playing = true
	yield(animated_sprite, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	animated_sprite.get_node("AnimationPlayer").play("Fade")
	yield(animated_sprite, "animation_finished")
	animated_sprite.queue_free()
	_toggle_overlay_displayed(false)
	_add_text_to_terminal(NEW_LINE)


func _trigger_Ransomware_end() -> void:
	self.emit_signal("overlay_triggered", 1)


func _add_text_to_terminal(text: String) -> void:
	GameProgress.terminal_text += text
	terminal_display.bbcode_text = GameProgress.terminal_text


func _toggle_overlay_displayed(enable: bool) -> void:
	overlay_displayed = enable
	_toggle_menu_buttons(enable)


func _toggle_menu_buttons(disable: bool) -> void:
	$ButtonContainer/NetworkButton.disabled = disable
	$ButtonContainer/TerminalButton.disabled = disable


func _on_GenericOverlayDisplay_overlay_finished(id) -> void:
	if id == 0:
		_handle_coffee_overlay_finished()


func _handle_coffee_overlay_finished() -> void:
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
		$Coffee.queue_free()
	else:
		_add_text_to_terminal(str("...", NEW_LINE))
		yield(get_tree().create_timer(1.0), "timeout")
	_toggle_overlay_displayed(false)
	terminal_display.bbcode_text = GameProgress.terminal_text


func _on_Minigame_visibility_changed(level):
	var node = null
	match(level):
		GameProgress.Level.RANSOMWARE:
			node = $Network/RansomwareRequestMiniGame
		GameProgress.Level.DDoS:
			node = $Network/DDoSInvaderMiniGame
	if node != null:
		_toggle_overlay_displayed(node.is_visible_in_tree())


func _on_MiniGame_game_won():
	self.emit_signal("level_finished_triggered", false)
	overlay_displayed = true


func _on_MiniGame_game_lost():
	self.emit_signal("level_finished_triggered", true)
	overlay_displayed = true
