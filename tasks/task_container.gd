extends VBoxContainer

signal level_completed()

var current_tasks := GameProgress.get_current_tasks().duplicate(true)
var taskEntries := []

func _ready() -> void:
	reset_nodes()

func _process(_delta):
	if current_tasks.hash() != GameProgress.get_current_tasks().hash():
		current_tasks = GameProgress.get_current_tasks().duplicate(true)
		for i in range(taskEntries.size()):
			_update_entry_text(taskEntries[i], current_tasks.values()[i])
		if GameProgress.is_level_completed() and GameProgress.level != GameProgress.Level.RANSOMWARE_TRIGGER:
			yield(get_tree().create_timer(2.0), "timeout")
			self.emit_signal("level_completed")
			current_tasks = GameProgress.get_current_tasks().duplicate(true)
			reset_nodes()

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

func _update_entry_text(taskEntry, task) -> void:
	if task[1] == "0":
		taskEntry.get_node("Description").bbcode_text = str("[color=black][right]", task[0], "[/right][/color]")
	else:
		taskEntry.get_node("Description").bbcode_text = str("[s][color=black][right]", task[0], "[/right][/color][/s]")	
