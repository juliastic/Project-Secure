extends VBoxContainer

signal in_game_backstory_triggered(index)
signal level_completed()
signal task_completed()

const TASK_ENTRY := preload("res://src/tasks/TaskEntry.tscn")

var current_tasks := GameProgress.get_current_tasks().duplicate(true)
var previous_tasks := {}
var level_transition_active: bool = false

func _ready() -> void:
	self.reset_nodes()

func _process(_delta):
	if current_tasks.hash() == GameProgress.get_current_tasks().hash() or level_transition_active:
		return
	
	previous_tasks = current_tasks
	current_tasks = GameProgress.get_current_tasks().duplicate(true)
	var i = 0
	var task_group = get_tree().get_nodes_in_group("tasks")
	if current_tasks.size() != task_group.size():
		self.reset_nodes()
	for key in current_tasks.keys():
		if current_tasks.keys() == previous_tasks.keys():
			_update_entry_text(task_group[i], current_tasks[key], previous_tasks[key])
		else:
			_update_entry_text(task_group[i], current_tasks[key])
		i += 1
	
	if GameProgress.level == GameProgress.Level.RANSOMWARE:
		if not _update_tasks([5, 6], [7], 1):
			_update_tasks([3, 4], [5, 6])
	elif GameProgress.level == GameProgress.Level.DDoS:
		_update_tasks([8, 9], [10])
	elif GameProgress.level == GameProgress.Level.SOCIAL_ENGINEERING:
		_update_tasks([11], [12])
	elif GameProgress.level == GameProgress.Level.EoP:
		_update_tasks([13], [14])
	
	if GameProgress.is_level_completed():
		level_transition_active = true
		if GameProgress.level != GameProgress.Level.RANSOMWARE_TRIGGER:
			self.emit_signal("level_completed")


func _update_tasks(task_ids = [], unlock_ids = [], index = 0):
	for task_id in task_ids:
		if not current_tasks[task_id][1]:
			return false
	for task_id in unlock_ids:
		if current_tasks[task_id][2]:
			return false
	for task_id in unlock_ids:
		GameProgress.get_current_tasks()[task_id][2] = true
	_trigger_in_game_backstory(index)
	return true


func _trigger_in_game_backstory(index: int) -> void:
	$AnimationPlayer.play("scale")
	self.emit_signal("in_game_backstory_triggered", index)


func reset_nodes() -> void:
	get_tree().call_group("tasks", "queue_free")
	for task in current_tasks.values():
		var task_instance = TASK_ENTRY.instance()
		task_instance.add_to_group("tasks")
		_update_entry_text(task_instance, task)
		self.add_child(task_instance)


func _update_entry_text(task_entry, task, previous_task = null) -> void:
	task_entry.call("show" if task[2] else "hide")

	var opening_tags = "[color=black][right]" if not task[1] else "[s][color=black][right]"
	var closing_tags = "[/right][/color]" if not task[1] else "[/right][/color][/s]"
	task_entry.get_node("Description").bbcode_text = str(opening_tags, task[0], closing_tags)
	
	if previous_task != null and task[1] and not previous_task[1]:
		self.emit_signal("task_completed")


func _on_Desktop_level_started():
	current_tasks = GameProgress.get_current_tasks().duplicate(true)
	self.reset_nodes()
	level_transition_active = false
	$AnimationPlayer.play("scale")
