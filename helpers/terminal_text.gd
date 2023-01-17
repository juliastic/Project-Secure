extends RichTextLabel

class_name TerminalText

func _ready() -> void:
	self.bbcode_enabled = true

	var normal_font = DynamicFont.new()
	normal_font.font_data = load("res://font/JetBrainsMono-Light.ttf")
	normal_font.size = 16
	self.set("custom_fonts/normal_font", normal_font)
	
	var bold_font = DynamicFont.new()
	bold_font.font_data = load("res://font/JetBrainsMono-Bold.ttf")
	bold_font.size = 16
	self.set("custom_fonts/bold_font", bold_font)
	
	var italic_font = DynamicFont.new()
	italic_font.font_data = load("res://font/JetBrainsMono-Italic.ttf")
	italic_font.size = 16
	self.set("custom_fonts/italics_font", italic_font)

	self.set("custom_constants/line_separation", -5)

