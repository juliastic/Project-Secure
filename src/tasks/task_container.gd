extends VBoxContainer

signal level_completed()
signal task_completed()

const TASK_ENTRY := preload("res://src/tasks/TaskEntry.tscn")

var current_tasks := GameProgress.get_current_tasks().duplicate(true)
var previous_tasks := {}
var level_transition_active: bool = false

func _ready() -> void:
	reset_nodes()

func _process(_delta):
	if current_tasks.hash() != GameProgress.get_current_tasks().hash() and not level_transition_active:
		previous_tasks = current_tasks
		current_tasks = GameProgress.get_current_tasks().duplicate(true)
		var i = 0
		var task_group = get_tree().get_nodes_in_group("tasks")
		if current_tasks.size() != task_group.size():
			reset_nodes()
		for key in current_tasks.keys():
			if current_tasks.keys() == previous_tasks.keys():
				_update_entry_text(task_group[i], current_tasks[key], previous_tasks[key])
			else:
				_update_entry_text(task_group[i], current_tasks[key])
			i += 1
		if GameProgress.level == GameProgress.Level.RANSOMWARE and current_tasks[3][1] == "1" and current_tasks[4][1] == "1" and GameProgress.get_current_tasks()[5][2] == "0":
			GameProgress.get_current_tasks()[5][2] = "1"
			GameProgress.get_current_tasks()[6][2] = "1"
			$AnimationPlayer.play("scale")
		elif GameProgress.level == GameProgress.Level.RANSOMWARE and current_tasks[5][1] == "1" and current_tasks[6][1] == "1":
			GameProgress.get_current_tasks()[7][2] = "1"
			$AnimationPlayer.play("scale")
		elif GameProgress.level == GameProgress.Level.DDoS and current_tasks[8][1] == "1" and current_tasks[9][1] == "1":
			GameProgress.get_current_tasks()[10][2] = "1"
		if GameProgress.is_level_completed():
			level_transition_active = true
			if GameProgress.level != GameProgress.Level.RANSOMWARE_TRIGGER:
				self.emit_signal("level_completed")

func reset_nodes() -> void:
	get_tree().call_group("tasks", "queue_free")
	for task in current_tasks.values():
		var task_instance = TASK_ENTRY.instance()
		task_instance.add_to_group("tasks")
		self._update_entry_text(task_instance, task)
		self.add_child(task_instance)

func _update_entry_text(task_entry, task, previous_task = null) -> void:
	task_entry.call("show" if task[2] == "1" else "hide")

	var opening_tags = "[color=black][right]" if task[1] == "0" else "[s][color=black][right]"
	var closing_tags = "[/right][/color]" if task[1] == "0" else "[/right][/color][/s]"
	task_entry.get_node("Description").bbcode_text = str(opening_tags, task[0], closing_tags)
	
	if previous_task != null and task[1] == "1" and previous_task[1] == "0":
		self.emit_signal("task_completed")

func _on_Desktop_level_started():
	current_tasks = GameProgress.get_current_tasks().duplicate(true)
	reset_nodes()
	level_transition_active = false
	$AnimationPlayer.play("scale")
