extends Node2D

signal overlay_triggered(id)
signal level_started()
signal coffee_completed()
signal level_finished_triggered(game_over)

onready var terminal_animation_player = $TerminalDisplay/TerminalAnimationPlayer
onready var terminal_display = $TerminalDisplay
onready var network_window = $Network
onready var network_info_text = $Network/InfoText

const TASK_COMPLETION_SOUND := preload("res://sounds/task_completed.mp3")
const BACKGROUND_IMG := preload("res://assets/background_computer.png")

const START_LINE = ">> "
const NEW_LINE = str("\n", START_LINE)
const GHOST_HIGHLIGHTER = "[ghost]|[/ghost]"

var terminal_input = ""
var overlay_displayed = false
var _current_coffee_fade_step = 0
var _current_level_overlay_fade_step = 0
var _trigger_coffee = true
var _trigger_level_overlay = true
var _network_button_pressed = false

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$BackgroundTexture.texture = BACKGROUND_IMG
	$BackgroundTexture.expand = true
	$ButtonContainer.add_constant_override("separation", 50)
	var animations = [$Coffee, $MachineGun, $LevelNode]
	for animation in animations:
		animation.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 1))
	terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER)
	if not GameProgress.intro_completed:
		$TransitionRect.queue_free()


func _input(event) -> void:
	var not_key_event = not event is InputEventKey or not event.is_pressed()
	if overlay_displayed or $Network/FirewallOverlay/HoneypotOverlay.is_visible_in_tree() or not GameProgress.intro_completed or not_key_event:
		return
	var level = GameProgress.level
	if event.scancode == KEY_ENTER:
		if len(terminal_input.strip_edges()) == 0:
			GameProgress.terminal_text += "\nPlease enter something first."
		elif not terminal_input.strip_edges() in TerminalCommands.COMMANDS:
			GameProgress.terminal_text += str("\nHm... I somehow have yet to learn what [i]", terminal_input, "[/i] means. Sorry about that ...\nEnter HELP to see an overview of my supported commands.")
		elif terminal_input == TerminalCommands.MIN:
			_terminal_toggle()
		elif terminal_input == TerminalCommands.CLEAR:
			GameProgress.terminal_text = START_LINE
			terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER)
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
		elif terminal_input == TerminalCommands.CHECK_CAPACITY and TerminalCommands.CHECK_CAPACITY in TerminalData.SUPPORTED_COMMANDS[level]:
			rng.randomize()
			GameProgress.terminal_text += str("\n", TerminalData.CHECK_CAPACITY_VALUES[level][rng.randi_range(0, 2)])
			GameProgress.get_current_tasks()[9][1] = true
		elif terminal_input == TerminalCommands.TOGGLE_HARDMODE and TerminalCommands.TOGGLE_HARDMODE in TerminalData.SUPPORTED_COMMANDS[level]:
			GameProgress.hardmode_enabled = !GameProgress.hardmode_enabled
			GameProgress.terminal_text += str("\nHardmode", " enabled" if GameProgress.hardmode_enabled else " disabled", ".")
		elif terminal_input == TerminalCommands.CREATE_FIREWALL:
			_print_command(terminal_input, TerminalData.CREATE_FIREWALL_VALUES, 3)
		elif terminal_input == TerminalCommands.LISTEN_REQUESTS:
			_print_command(terminal_input, TerminalData.LISTEN_REQUESTS_VALUES, 4)
		elif terminal_input == TerminalCommands.ENABLE_IDS:
			_print_command(terminal_input, TerminalData.ENABLE_IDS_VALUES, 8)
		elif terminal_input == TerminalCommands.CHECK_IDS:
			_print_command(terminal_input, TerminalData.CHECK_IDS_VALUES, 11)
		elif terminal_input == TerminalCommands.CHECK_EXPLOITS:
			_print_command(terminal_input, TerminalData.CHECK_EXPLOITS_VALUES, 13)
		
		if terminal_input != TerminalCommands.CLEAR:
			_add_text_to_terminal(str("\n", START_LINE if not overlay_displayed else ""), terminal_input != TerminalCommands.GRAB_COFFEE)
		
		if level == GameProgress.Level.TUTORIAL and not GameProgress.get_current_tasks()[0][1] and terminal_input in TerminalData.SUPPORTED_COMMANDS[level]:
			GameProgress.get_current_tasks()[0][1] = true
		terminal_input = ""
	elif terminal_input.length() > 0 and event.scancode == KEY_BACKSPACE or event.scancode == KEY_DELETE:
		GameProgress.terminal_text = GameProgress.terminal_text.left(GameProgress.terminal_text.length() - 1)
		terminal_input = terminal_input.left(terminal_input.length() - 1)
		terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER)
	elif event.scancode in KeyConstants.KEY_MAP and GameProgress.terminal_shown:
		var letter = KeyConstants.KEY_MAP[event.scancode]
		GameProgress.terminal_text += letter
		terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER)
		terminal_input += letter


func _print_command(command: String, data_list, task_id: int) -> void:
	if not command in TerminalData.SUPPORTED_COMMANDS[GameProgress.level]:
		_add_text_to_terminal(str(command, " is not relevant to achieve your current goal. Execute HELP to see all the currently supported commands."))
		return
	var command_invoked_index = 1 if GameProgress.get_current_tasks()[task_id][1] else 0
	GameProgress.terminal_text += str("\n", data_list[GameProgress.level][command_invoked_index])
	if command_invoked_index == 0:
		GameProgress.get_current_tasks()[task_id][1] = true


func _on_NetworkButton_pressed() -> void:
	if GameProgress.level == GameProgress.Level.TUTORIAL:
		_network_button_pressed = true
	var tutorial_active = GameProgress.level == GameProgress.Level.TUTORIAL or GameProgress.level == GameProgress.Level.RANSOMWARE_TRIGGER
	var current_tasks = GameProgress.get_current_tasks()
	var first_stage_ransomware = GameProgress.level == GameProgress.Level.RANSOMWARE and (not current_tasks[3][1] or not current_tasks[4][1])
	var first_stage_ddos = GameProgress.level == GameProgress.Level.DDoS and not(current_tasks[8][1] and current_tasks[9][1])
	var first_stage_social_engineering = GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING and not current_tasks[11][1]
	var first_stage_eop = GameProgress.level == GameProgress.Level.EoP and not current_tasks[13][1]
	var first_stage_active = tutorial_active or first_stage_ransomware or first_stage_social_engineering or first_stage_ddos or first_stage_eop
	if first_stage_ransomware:
		network_info_text.bbcode_text = "[center]Please create a Firewall and enable Network listening in the Terminal first.[/center]"
	elif first_stage_ddos:
		network_info_text.bbcode_text = "[center]Please enable IDS and check our capacity first before you proceed.[/center]"
	elif first_stage_social_engineering:
		network_info_text.bbcode_text = "[center]It's dangerous out there. Please check the IDS first.[/center]"
	elif first_stage_eop:
		network_info_text.bbcode_text = "[center]We need to check the exploits first![/center]"
	_toggle_node(network_info_text, first_stage_active)
	network_window.set_position(Vector2(650, 400))
	network_window.show()


func _toggle_node(node: Node, show: bool) -> void:
	node.call("show" if show else "hide")


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
	if $AudioPlayer.is_playing():
		return
	$AudioPlayer.stream = TASK_COMPLETION_SOUND
	$AudioPlayer.play()


func _handle_level_switch() -> void:
	terminal_input = ""
	_toggle_overlay_displayed(true)
	GameProgress.set_next_level()
	network_window.hide()
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
	yield(get_node("LevelNode/AnimationPlayer"), "animation_finished")
	$LevelNode.hide()
	if GameProgress.level == GameProgress.Level.DDoS or GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
		_trigger_level_start()
	else:
		_toggle_overlay_displayed(false)
		yield(get_tree().create_timer(0.4), "timeout")
		_add_text_to_terminal(str("\n...\n[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]", NEW_LINE), true)


func _trigger_level_start() -> void:
	var animated_sprite = null
	if GameProgress.level == GameProgress.Level.DDoS:
		animated_sprite = $MachineGun
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
		animated_sprite = $Disguise

	if animated_sprite == null:
		return
		
	_add_text_to_terminal("\n...\n")
	_toggle_overlay_displayed(true)
	animated_sprite.show()
	animated_sprite.get_node("AnimationPlayer").play_backwards("Fade")
	animated_sprite.playing = true
	yield(animated_sprite, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	animated_sprite.get_node("AnimationPlayer").play("Fade")
	yield(animated_sprite, "animation_finished")
	animated_sprite.queue_free()
	_add_text_to_terminal(str("[b]", TerminalData.BACKSTORY_VALUES[GameProgress.level], "[/b]"))
	_toggle_overlay_displayed(false)
	_add_text_to_terminal(NEW_LINE, true)


func _add_text_to_terminal(text: String, show_highlighter: bool = false) -> void:
	GameProgress.terminal_text += text
	terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER if show_highlighter else "")


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
		$Coffee.play()
		yield(get_node("Coffee"), "animation_finished")
		terminal_display.add_text("...\n")
		yield(get_tree().create_timer(1.0), "timeout")
		terminal_display.add_text("...\n")
		yield(get_tree().create_timer(1.0), "timeout")
		_add_text_to_terminal(TerminalData.GRAB_COFFEE_VALUES[GameProgress.level])
		yield(get_tree().create_timer(1.0), "timeout")
		$Coffee/AnimationPlayer.play("Fade")
		self.emit_signal("coffee_completed")
		_handle_level_switch()
		$Coffee.queue_free()
	else:
		_add_text_to_terminal(str("...", NEW_LINE))
		yield(get_tree().create_timer(1.0), "timeout")
	_toggle_overlay_displayed(false)
	terminal_display.bbcode_text = str(GameProgress.terminal_text, GHOST_HIGHLIGHTER)


func _on_Minigame_visibility_changed(level) -> void:
	var node = null
	match(level):
		GameProgress.Level.RANSOMWARE:
			node = $Network/RansomwareRequestMiniGame
		GameProgress.Level.DDoS:
			node = $Network/DDoSInvaderMiniGame
		GameProgress.Level.SOCIAL_ENGINEERING:
			node = $Network/SocialEngineeringMiniGame
		GameProgress.Level.EoP:
			node = $Network/EoPMiniGame
	if node != null:
		_toggle_overlay_displayed(node.is_visible_in_tree())
		if not node.is_visible_in_tree() and not terminal_display.bbcode_text.ends_with(GHOST_HIGHLIGHTER):
			terminal_display.bbcode_text += GHOST_HIGHLIGHTER
		elif node.is_visible_in_tree() and terminal_display.bbcode_text.ends_with(GHOST_HIGHLIGHTER):
			terminal_display.bbcode_text = terminal_display.bbcode_text.left(len(terminal_display.bbcode_text) - len(GHOST_HIGHLIGHTER))


func _on_MiniGame_game_won() -> void:
	self.emit_signal("level_finished_triggered", false)
	overlay_displayed = true


func _on_MiniGame_game_lost() -> void:
	self.emit_signal("level_finished_triggered", true)
	overlay_displayed = true


func _on_Desktop_tree_entered() -> void:
	if not GameProgress.intro_completed:
		return
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play("Fade")
	yield($TransitionRect/AnimationPlayer, "animation_finished")


func _on_TaskContainer_in_game_backstory_triggered(index: int) -> void:
	_add_text_to_terminal(str("\n...\n", TerminalData.IN_LEVEL_BACKSTORY_VALUES[GameProgress.level][index], NEW_LINE), true)


func _on_Network_hide() -> void:
	if GameProgress.level == GameProgress.Level.TUTORIAL and _network_button_pressed:
		GameProgress.get_current_tasks()[1][1] = true
