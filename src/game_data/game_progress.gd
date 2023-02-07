extends Node


enum Level {
	TUTORIAL,
	RANSOMWARE_TRIGGER,
	RANSOMWARE,
	DDoS,
	SOCIAL_ENGINEERING,
	EoP
}

var terminal_text = str(
	"Welcome, as you know: I'm Bob. I know that this Terminal Thing might be a bit confusing to you. ",
	"As a little heads up: Type HELP and press ENTER to understand how to use my features or if you are lost. I should be able to help you.\n>> ")

# core game variables

var terminal_shown = true
var intro_completed = true

var level = Level.EoP

var hardmode_enabled = false

var level_score := {
	Level.RANSOMWARE: 100,
	Level.DDoS: 0,
	Level.SOCIAL_ENGINEERING: 0,
	Level.EoP: 0 
}

#

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
	0: ["Execute one command in the terminal", "0", "1"], 
	1: ["Open the Network Tab", "0", "1"]
}

const _tasks_ransomware_trigger := {
	2: ["Grab some coffee", "0", "1"]
}

const _tasks_ransomware := {
	3: ["Create Firewall", "0", "1"],
	4: ["Listen to Network Requests", "0", "1"],
	5: ["Enable Firewall", "0", "0"],
	6: ["Enable Honeypot", "0", "0"],
	7: ["Mark Suspicious Internal Requests", "0", "0"]
}

const _tasks_ddos := {
	8: ["Enable Intrusion Detection System", "0", "1"],
	9: ["Check the server's capacity", "0", "1"],
	10: ["Defend against the attackers", "0", "0"]
}

const _tasks_social_engineering := {
	11: ["Check if an intruder has breached the system", "0", "1"],
	12: ["Safe the system!", "0", "0"]
}

const _tasks_eop := {
	13: ["Check for exploits", "0", "1"],
	14: ["CATCH THE INTRUDER", "0", "0"],
}

var tasks := {
	Level.TUTORIAL: _tasks_tutorial, 
	Level.RANSOMWARE_TRIGGER: _tasks_ransomware_trigger, 
	Level.RANSOMWARE: _tasks_ransomware,
	Level.DDoS: _tasks_ddos,
	Level.SOCIAL_ENGINEERING: _tasks_social_engineering,
	Level.EoP: _tasks_eop
}

var _initial_tasks = tasks.duplicate(true)

func get_level_name() -> String:
	match (level):
		2: return "RANSOMWARE"
		3: return "DISTRIBUTED DENIAL OF SERVICE"
		4: return "SOCIAL ENGINEERING"
		5: return "ELEVATION OF PRIVILEGES"
		_: return ""


func set_next_level() -> void:
	level = tasks.keys()[level + 1]


func get_current_tasks() -> Dictionary:
	return tasks[level]


func is_level_completed() -> bool:
	var current_tasks := get_current_tasks()
	for value in current_tasks.values():
		if value[1] == "0":
			return false
	return true


func complete_level() -> void:
	var current_tasks := get_current_tasks()
	for value in current_tasks.values():
		value[1] = "1"


func reset_level() -> void:
	if level == Level.RANSOMWARE:
		level_score[level] = 100
		Requests.blocked_requests = []
	else:
		level_score[level] = 0


func reset_game() -> void:
	terminal_text = str(
		"Welcome, as you know: I'm Bob. I know that this Terminal Thing might be a bit confusing to you. ",
		"As a little heads up: Type HELP and press ENTER to understand how to use my features or if you are lost. I should be able to help you.\n>> ")
	terminal_shown = true
	intro_completed = false
	level = GameProgress.Level.TUTORIAL
	tasks = _initial_tasks
