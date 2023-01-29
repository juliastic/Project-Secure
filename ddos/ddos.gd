extends WindowDialog

onready var bullet_container := preload("Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event) -> void:
	if self.is_visible_in_tree() and event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		var bullet = bullet_container.instance()
		self.add_child(bullet)
		#todo: handle movement here
		#bullet.connect("button_down", get_parent().get_parent(), "_on_Request_pressed", [str(key)])

func _on_GameStart_pressed():
	$GameStartNode/AnimationPlayer.play("Fade")
	yield($GameStartNode.get_node("AnimationPlayer"), "animation_finished")
	$GameStartNode.set_modulate(lerp(get_modulate(), Color(1, 1, 1, 1), 1))
	$GameStartNode.hide()
