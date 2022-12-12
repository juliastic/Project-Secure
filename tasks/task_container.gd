extends VBoxContainer

var current_tasks := GameProgress.get_current_tasks().duplicate(true)
var taskEntries := []

func _ready():
	var taskEntry = preload("TaskEntry.tscn")
	for task in current_tasks.values():
		var taskInstance = taskEntry.instance()
		taskEntries.append(taskInstance)
		self._update_entry_text(taskInstance, task)
		self.add_child(taskInstance)

func _process(_delta):
	if current_tasks.hash() != GameProgress.get_current_tasks().hash():
		current_tasks = GameProgress.get_current_tasks().duplicate(true)
		for i in range(taskEntries.size()):
			_update_entry_text(taskEntries[i], current_tasks.values()[i])

func _update_entry_text(taskEntry, task) -> void:
	if task[1] == "0":
		taskEntry.get_node("Description").bbcode_text = str("[right]", task[0], "[/right]")
	else:
		taskEntry.get_node("Description").bbcode_text = str("[s][right]", task[0], "[/right][/s]")	
