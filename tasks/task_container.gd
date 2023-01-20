extends VBoxContainer

signal level_completed()
signal task_completed()

var current_tasks := GameProgress.get_current_tasks().duplicate(true)
var previous_tasks := {}
var taskEntries := []
var level_transition_active = false

func _ready() -> void:
	reset_nodes()

func _process(_delta):
	if current_tasks.hash() != GameProgress.get_current_tasks().hash() and not level_transition_active:
		previous_tasks = current_tasks
		current_tasks = GameProgress.get_current_tasks().duplicate(true)
		var i = 0
		for key in current_tasks.keys():
			if current_tasks.keys() == previous_tasks.keys():
				_update_entry_text(taskEntries[i], current_tasks[key], previous_tasks[key])
			else:
				_update_entry_text(taskEntries[i], current_tasks[key])
			i += 1
		if GameProgress.level == GameProgress.Level.RANSOMWARE and current_tasks[3][1] == "1" and current_tasks[4][1] == "1":
			GameProgress.get_current_tasks()[5][2] = "1"
		if GameProgress.is_level_completed() and GameProgress.level != GameProgress.Level.RANSOMWARE_TRIGGER:
			self.emit_signal("level_completed")
			level_transition_active = true

func reset_nodes() -> void:
	for task in taskEntries:
		task.free()
	taskEntries = []
	var taskEntry = preload("res://tasks/TaskEntry.tscn")
	for task in current_tasks.values():
		var taskInstance = taskEntry.instance()
		taskEntries.append(taskInstance)
		self._update_entry_text(taskInstance, task)
		self.add_child(taskInstance)

func _update_entry_text(taskEntry, task, previous_task = null) -> void:
	if task[2] == "0":
		taskEntry.hide()
	else:
		taskEntry.show()

	if task[1] == "0":
		taskEntry.get_node("Description").bbcode_text = str("[color=black][right]", task[0], "[/right][/color]")
	else:
		taskEntry.get_node("Description").bbcode_text = str("[s][color=black][right]", task[0], "[/right][/color][/s]")
	
	if previous_task != null and task[1] == "1" and previous_task[1] == "0":
		self.emit_signal("task_completed")

func _on_Desktop_level_started():
	current_tasks = GameProgress.get_current_tasks().duplicate(true)
	reset_nodes()
	level_transition_active = false
