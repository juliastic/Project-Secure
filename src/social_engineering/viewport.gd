extends Viewport

signal game_won()
signal game_lost()

func prepare_level() -> void:
	pass #generate cards here
	# connect each animation_finished with this script
	# node of name -> id+people/actions
	# two groups: people_nodes/action_nodes
	# save which cards are currently opened -> if no match, close them again

func _on_LevelTimer_timeout() -> void:
	pass # Replace with function body.
