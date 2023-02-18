extends AnimatedSprite

signal card_toggled(card_data)

onready var animation_player := $Description/AnimationPlayer

var ignore_input: bool = false
var card_data: CardData

func _input(_event) -> void:
	if ignore_input and $Button.mouse_filter != Control.MOUSE_FILTER_IGNORE:
		$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif not ignore_input and $Button.mouse_filter != Control.MOUSE_FILTER_STOP:
		$Button.mouse_filter = Control.MOUSE_FILTER_STOP

func init(p_card_data: CardData) -> void:
	card_data = p_card_data
	var type = "PERSON" if card_data.type == 0 else "ACTION"
	$Description.bbcode_text = str("[center][b]", type, "[/b][/center]\n", card_data.description)


func flip_card() -> void:
	card_data.open = !card_data.open
	self.play("default", not card_data.open)
	if card_data.open:
		animation_player.play("Fade")
	else:
		animation_player.play_backwards("Fade")
		

func remove_card() -> void:
	$AnimationPlayer.play_backwards("Fade")
	yield($AnimationPlayer, "animation_finished")
	self.queue_free()


func _on_Button_pressed() -> void:
	flip_card()
	self.emit_signal("card_toggled", card_data)
