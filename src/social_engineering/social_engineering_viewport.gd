extends Viewport

signal game_won()
signal game_lost()

const MEMORY_CARD := preload("res://src/social_engineering/MemoryCard.tscn")

const MAX_X = 950
const MAX_Y = 765
const X_STEP = 250
const Y_STEP = 320

var open_cards = []
var level_time = 60
var id = 0

func prepare_level() -> void:
	$GameInformationContainer/Time.bbcode_text = str("Time: ", level_time)
	$GameInformationContainer/Score.bbcode_text = str("Points: ", GameProgress.level_score[GameProgress.level])
	if not GameProgress.hardmode_enabled:
		for _i in range(0, 4):
			MemoryData.cards.remove(0)
	randomize()
	MemoryData.cards.shuffle()
	var current_card_position = Vector2(125, 200)
	for card_data in MemoryData.cards:
		card_data.open = false
		card_data.unique_id += id
		id += 10
		var card = MEMORY_CARD.instance()
		card.init(card_data)
		card.position = current_card_position
		card.connect("card_toggled", self, "on_Card_toggled")
		card.set_name(str(card_data.unique_id))
		card.add_to_group("cards")
		if current_card_position.x >= MAX_X:
			current_card_position.x = 125
			current_card_position.y += Y_STEP
		else:
			current_card_position.x += X_STEP
		self.add_child(card)


func reset_level() -> void:
	open_cards = []
	$LevelTimer.start()
	level_time = 60
	GameProgress.level_score[GameProgress.level] = 0
	get_tree().call_group("cards", "queue_free")
	self.prepare_level()


func on_Card_toggled(card_data: CardData) -> void:
	open_cards.append(card_data)
	if open_cards.size() < 2:
		return
	get_tree().set_group("cards", "ignore_input", true)
	yield(get_tree().create_timer(3.0), "timeout")
	var cards_match = open_cards[0].id == open_cards[1].id
	for open_card in open_cards:
		var card_node = get_node(str(open_card.unique_id))
		if cards_match:
			card_node.remove_from_group("cards")
		card_node.call("remove_card" if cards_match else "flip_card")
	open_cards = []
	yield(get_tree().create_timer(1.0), "timeout")
	if cards_match:
		GameProgress.level_score[GameProgress.level] += 5
		$GameInformationContainer/Score.bbcode_text = str("Points: ", GameProgress.level_score[GameProgress.level])
		if get_tree().get_nodes_in_group("cards").size() == 2:
			self.emit_signal("game_won")
	get_tree().set_group("cards", "ignore_input", false)


func _on_LevelTimer_timeout() -> void:
	level_time -= 1
	$GameInformationContainer/Time.bbcode_text = str("Time: ", level_time)
	if level_time == 0:
		self.emit_signal("game_lost")


func _on_LevelFinishedNode_level_reset_triggered():
	if GameProgress.level != GameProgress.Level.SOCIAL_ENGINEERING:
		return
	reset_level()
