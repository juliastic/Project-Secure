extends Node

var terminal_text = str(
	"Welcome, as you know: I'm Bob. I know that this Terminal Thing might be a bit confusing to you. ",
	"As a little heads up: Type HELP and press ENTER to understand how to use my features.\n>> ")

var terminal_shown = true
var intro_completed = false
var level = Level.TUTORIAL

var firewall_settings := {
	"authenticated_users": false,
	"request_limit": false,
	"network_logging": false
}
var honeypot_settings := {
	"attack_information": false,
	"accessed_data": false,
	"file_name": ""
}

const _tasks_tutorial := {
	0: ["Execute one command in the terminal", "0"], 
	1: ["Open the Network Tab", "0"]
}
const _tasks_ransomware_trigger := {
	2: ["Execute Grab Coffee Command", "0"]
}
const _tasks_ransomware := {
	3: ["Setup Firewall", "0"]
}

var tasks := {Level.TUTORIAL: _tasks_tutorial, Level.RANSOMWARE_TRIGGER: _tasks_ransomware_trigger, Level.RANSOMWARE: _tasks_ransomware}

enum Level {
	TUTORIAL,
	RANSOMWARE_TRIGGER,
	RANSOMWARE,
	DDoS,
	SOCIAL_ENGINEERING,
	EoP
}

func get_level_name() -> String:
	match (level):
		2: return "RANSOMWARE"
		3: return "DISTRIBUTED DENIAL OF SERVICE"
		4: return "SOCIAL ENGINEERING"
		5: return "ELEVATION OF PRIVILEGES"
		_: return ""

func set_next_level() -> void:
	level = tasks.keys()[level + 1]

func get_node_for_level() -> String:
	return "res://desktop/Desktop.tscn"
	
func get_current_tasks() -> Dictionary:
	return tasks[level]
	
func is_level_completed() -> bool:
	var current_tasks := get_current_tasks()
	for value in current_tasks.values():
		if value[1] == "0":
			return false
	return true
