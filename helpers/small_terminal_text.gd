extends TerminalText
class_name SmallTerminalText

func _ready() -> void:
	self.get_font("normal_font").size = 12
	self.get_font("bold_font").size = 12
	self.get_font("italics_font").size = 12
	
	self.set("custom_constants/line_separation", 0)
