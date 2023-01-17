extends Node

const SUPPORTED_COMMANDS := {
	GameProgress.Level.TUTORIAL: ["MIN", "GRAB COFFEE", "HELP", "BACKSTORY", "LIST TERMS", "EXPLAIN"], 
	GameProgress.Level.RANSOMWARE: ["MIN", "GRAB COFFEE", "HELP", "BACKSTORY", "LIST TERMS", "EXPLAIN"], 
	GameProgress.Level.DDoS: ["MIN", "GRAB COFFEE", "HELP", "BACKSTORY", "LIST TERMS", "EXPLAIN"]}

const COMMANDS := {"LIST TERMS": {GameProgress.Level.RANSOMWARE: "Honeypot: Something cool", GameProgress.Level.DDoS: "Honeypot: Something sweet"},
	"BACKSTORY": {GameProgress.Level.RANSOMWARE: "Just another day in the office", GameProgress.Level.DDoS: "Honeypot: Something sweet"},
	"EXPLAIN": {GameProgress.Level.RANSOMWARE: {"RANSOMWARE": "Something not so great"}, GameProgress.Level.DDoS: {"RANSOMWARE": "Something not so great"}},
	"HELP": {GameProgress.Level.TUTORIAL: "Yay", GameProgress.Level.RANSOMWARE: "This is another fancy help text", 
		GameProgress.Level.DDoS: "This is not another fancy help text"}}

const LIST_TERMS_VALUES = {
	GameProgress.Level.TUTORIAL: "Network: You know it",
	GameProgress.Level.RANSOMWARE: "Honeypot: Something cool",
	GameProgress.Level.DDoS: "Honeypot: Something sweet"
}

const BACKSTORY_VALUES = {
	GameProgress.Level.TUTORIAL: "Fun?",
	GameProgress.Level.RANSOMWARE: "Just another day in the office",
	GameProgress.Level.DDoS: "Honeypot: Something sweet"
}

const EXPLAIN_VALUES = {
	GameProgress.Level.TUTORIAL: {"RANSOMWARE": "Something not so great"},
	GameProgress.Level.RANSOMWARE: {"RANSOMWARE": "Something not so great"},
	GameProgress.Level.DDoS: {"RANSOMWARE": "Something not so great"}
}

const HELP_VALUES = {
	GameProgress.Level.TUTORIAL: "Yay",
	GameProgress.Level.RANSOMWARE: "This is another fancy help text",
	GameProgress.Level.DDoS: "This is not another fancy help text"
}

func generate_help_text(level: int) -> String:
	var help_text = "I understand the following commands ..."
	if "MIN" in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]MIN[/b]: Minimises me. Not that you'd ever want to do that."
	if "GRAB COFFEE" in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]GRAB COFFEE[/b]: Humans also need a sometimes break (even though I don't understand why - they're so unproductive). Might have side effects."
	if "BACKSTORY" in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]BACKSTORY[/b]: I give you a backstory to the current chapter. It's ok. Humans are forgetful"
	if "LIST TERMS" in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]LIST TERMS[/b]: List all terms understood by me. List might expand as you progress in your tasks."
	if "EXPLAIN" in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]EXPLAIN <TERM>[/b]: Explains a specific term. I'm all-knowing, you know."
	return help_text
	#return str("I understand the following commands ...\n",
	#"[b]MIN[/b]: Minimises me. Not that you'd ever want to do that.\n",
	#"[b]GRAB COFFEE[/b]: Humans also need a sometimes break (even though I don't understand why - they're so unproductive). Might have side effects.\n",
	#"[b]BACKSTORY[/b]: I give you a backstory to the current chapter. It's ok. Humans are forgetful\n",
	#"[b]LIST TERMS[/b]: List all terms understood by me. List might expand as you progress in your tasks.\n",
	#"[b]EXPLAIN <TERM>[/b]: Explains a specific term. I'm all-knowing, you know.")

func generate_list_terms(level: int) -> String:
	var term_list = "I can give you more information on the following terms:"
	for term in EXPLAIN_VALUES[level].keys():
		term_list += str("\n...[b]", term, "[/b]")
	return term_list
