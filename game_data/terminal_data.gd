extends Node

const SUPPORTED_COMMANDS := {
	GameProgress.Level.TUTORIAL: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN], 
	GameProgress.Level.RANSOMWARE: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.LISTEN_REQUESTS, TerminalCommands.CREATE_FIREWALL],
	GameProgress.Level.DDoS: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.CAPACITY, TerminalCommands.ENABLE_IDS]}

const BACKSTORY_VALUES = {
	GameProgress.Level.TUTORIAL: "You're getting to know the system. Don't worry so much about what you're doing.",
	GameProgress.Level.RANSOMWARE: "This would be another day in the office if it wasn't for your coworker. Act swiftly. Block the attacker from our network.",
	GameProgress.Level.DDoS: "We're under fire. Block the attackers as soon as possible. The sooner you block them, the faster our systems can act normally again. Usually this would be the job of an Intrusion Prevention System but you are all we got."
}

const EXPLAIN_VALUES = {
	GameProgress.Level.TUTORIAL: {},
	GameProgress.Level.RANSOMWARE: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.",
		"FIREWALL": "A type of network protection to filter incoming network traffic."
		},
	GameProgress.Level.DDoS: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.", 
		"INTRUSION DETECTION SYSTEM": "IDS can be used to detect and alert on suspicious or malicious traffic on the network.", 
		"INTRUSION PREVENTION SYSTEM": "IPS can automatically block malicious traffic in real-time.",
		"FIREWALL": "A type of network protection to filter incoming network traffic."
		}
}

const CREATE_FIREWALL_VALUES = {
	GameProgress.Level.RANSOMWARE: "Firewall created. You can go ahead and play around in the Network settings. However, please ensure that everything is enabled for it to function properly."
}

const LISTEN_REQUESTS_VALUES = {
	GameProgress.Level.RANSOMWARE: "Fetching of requests active. Please note that I only display requests if the firewall is properly enabled."
}

const CAPACITY_VALUES = {
	GameProgress.Level.DDoS: ["We're at 0%.", "We're at 10%.", "ITS OVER 9000%."]
}

const ENABLE_IDS_VALUES = {
	GameProgress.Level.DDoS: "IDS enables. You're safe to proceed."
}

func generate_help_text(level: int) -> String:
	var help_text = "I understand the following commands ..."
	if TerminalCommands.MIN in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]MIN[/b]: Minimises me. Not that you'd ever want to do that."
	if TerminalCommands.GRAB_COFFEE in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]GRAB COFFEE[/b]: Humans also need a sometimes break (even though I don't understand why - they're so unproductive). Might have side effects."
	if TerminalCommands.BACKSTORY in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]BACKSTORY[/b]: I give you a backstory to the current chapter. It's ok. Humans are forgetful."
	if TerminalCommands.LIST_TERMS in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]LIST TERMS[/b]: Lists all terms understood by me. The list might expand as you progress in your tasks."
	if TerminalCommands.EXPLAIN in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]EXPLAIN <TERM>[/b]: Explains a specific term. I'm all-knowing, you know."
	if TerminalCommands.CREATE_FIREWALL in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]CREATE FIREWALL[/b]: Creates a Firewall used for filtering incoming Network Requests. Necessary to execute once so I know you [i]really[/i] want it enabled."
	if TerminalCommands.LISTEN_REQUESTS in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]LISTEN REQUESTS[/b]: Tells me that you want me to fetch the most recent requests. Necessary to execute once so I know you [i]really[/i] want it enabled."
	if TerminalCommands.ENABLE_IDS in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]ENABLE IDS[/b]: Enables the Intrusion Detection System. Highlights suspcious requests in form of a [i]counter[/i]. I'm colour blind so I couldn't rely on colours."
	if TerminalCommands.CAPACITY in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]CAPACITY[/b]: Displays the currenty request capacity of ours servers. The closer it is to 100%, the closer our system is to failure. If it's over 9000, all is lost."
	return help_text

func generate_list_terms(level: int) -> String:
	var term_list = "I can give you more information on the following terms:"
	for term in EXPLAIN_VALUES[level].keys():
		term_list += str("\n...[b]", term, "[/b]")
	return term_list
