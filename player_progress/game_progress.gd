extends Node

var terminal_text = "Welcome, press any key to continue\n>> "
var terminal_shown = true
var intro_completed = false
var level = Level.RANSOMWARE

const _tasks_ransomware := {0: ["Execute one command in the terminal", "0"], 1: ["Open the Network Tab", "1"], 2: ["More things", "0"]}

var tasks := {Level.RANSOMWARE: _tasks_ransomware}

enum Level {
	DDoS,
	SOCIAL_ENGINEERING,
	RANSOMWARE,
	EoP
}

func get_node_for_level() -> String:
	return "res://desktop/Desktop.tscn"
	
func get_current_tasks() -> Dictionary:
	return tasks[level]
