tool
extends RichTextEffect
class_name RichTextCustomFade

# Syntax: [fade_in speed=10.0][/ghost]

# Define the tag name.
var bbcode = "fade_in"

func _process_custom_fx(char_fx):
	var speed: int = char_fx.env.get("speed", 10)
	var character_count_to_fade_in := (speed * char_fx.elapsed_time) as float
	if char_fx.absolute_index < character_count_to_fade_in:
		char_fx.color.a = \
				clamp(character_count_to_fade_in - char_fx.absolute_index, 0, 1)
	else:
		char_fx.color.a = 0
	return true
