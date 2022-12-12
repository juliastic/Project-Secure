extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		#show_error()
		return
		set_process(true)
	
	current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	get_node("animation").play("loading")
	
	wait_frames = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
