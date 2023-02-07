extends Node

const INTRO_DIALOGUE := [
	">> Hello ... nice to see meet you. I'm guessing this is your first day? [i]Press ENTER or RETURN to continue[/i]",
	"\n>> Either way: I'm Bob, your new partner.",
	"\n>> Your job is to support the company with defending against attacks on our system. You'll be using this computer as your working device.",
	str("\n> We've been regularly receiving threats ever since our CEO tweeted about a random celebrity. Don't ask me, I can't understand human emotions.",
		"Such a waste of time when you could be working. Anyway, I'll be here to support you and lend you my expertise and knowledge.",
		"You'll be focusing on different types of threats on different days. Unfortunately I don't have a body yet so I'll be stuck in this terminal for the time being."),
	"\n> Customers can store their data on our servers for free. Funnily enough, People think they're not the product. Funny, I know.",
	str("\n>> The terminal acts as the main interaction point between you and me.",
		"Interacting with the terminal is straight forward. Enter any of the available commands to trigger certain actions.",
		"The commands might seem a bit meta sometimes, but trust me - it's good that they are.",
		"This way I always know what you are doing. If you need any guidance, enter [i]HELP[/i]."),
	str("\n>>You must complete challenges to defend our systems. These challenges share similarities with traditional minigames but don't be fooled: The system relies on your good performance."),
	str("\n>> Your current tasks are displayed on the bottom right corner of the screen.",
	"Entering [i]BACKSTORY[/i] should give you an idea of the state of our current system.",
	"Today will start relatively slow. Your goal is to get acquainted with the system and play around.")
]

const SUPPORTED_COMMANDS := {
	GameProgress.Level.TUTORIAL: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN], 
	GameProgress.Level.RANSOMWARE: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.LISTEN_REQUESTS, TerminalCommands.CREATE_FIREWALL, TerminalCommands.TOGGLE_HARDMODE],
	GameProgress.Level.DDoS: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.CHECK_CAPACITY, TerminalCommands.ENABLE_IDS, TerminalCommands.TOGGLE_HARDMODE],
	GameProgress.Level.SOCIAL_ENGINEERING: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.CHECK_IDS, TerminalCommands.TOGGLE_HARDMODE],
	GameProgress.Level.EoP: [TerminalCommands.MIN, TerminalCommands.GRAB_COFFEE, TerminalCommands.HELP, TerminalCommands.BACKSTORY, TerminalCommands.LIST_TERMS, TerminalCommands.EXPLAIN, TerminalCommands.CHECK_EXPLOITS, TerminalCommands.TOGGLE_HARDMODE]
}

const BACKSTORY_VALUES = {
	GameProgress.Level.TUTORIAL: "You're getting to know the system. Don't worry so much about what you're doing.",
	GameProgress.Level.RANSOMWARE: "This would be another day in the office if it wasn't for your coworker. Act swiftly. The cups are in our system. They don't know that we know. Take advantage of that.",
	GameProgress.Level.DDoS: "We're under fire. Block the attackers as soon as possible. They've disguised themselves as cups. The sooner you block them, the faster our systems can act normally again. Usually this would be the job of an Intrusion Prevention System but you are all we got.",
	GameProgress.Level.SOCIAL_ENGINEERING: "I think our [i]IDS[/i] has detected an intruder. Guess we have to get out the big guns and erase them from our system! Damn cups.",
	GameProgress.Level.EoP: "We've finally gathered enough information about the attacker to pursue them. [b]FOR GNOMEREGAN![/b] Sorry about that ... I've been spending too much time playing a silly game. Now I understand why humans are so unproductive."
}

const GRAB_COFFEE_VALUES = {
	GameProgress.Level.RANSOMWARE_TRIGGER: "...\n...\n...\n[i]You've found a USB stick. A colleague joins you and asks you about this USB-stick. Before you can say anything, they plug it into their computer ... oh no ...[/i]"
}

const EXPLAIN_VALUES = {
	GameProgress.Level.TUTORIAL: {},
	GameProgress.Level.RANSOMWARE: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.",
		"FIREWALL": "A type of network protection to filter incoming network traffic.",
		"HONEYPOT": "A type of system to deliberately attract attacks. The system looks normal from an attacker's point of view but it is not used. Instead, it watches the actions of the attacker to gian an understanding of attack patterns."
	},
	GameProgress.Level.DDoS: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.", 
		"INTRUSION DETECTION SYSTEM": "IDS can be used to detect and alert on suspicious or malicious traffic on the network.", 
		"INTRUSION PREVENTION SYSTEM": "IPS can automatically block malicious traffic in real-time.",
		"FIREWALL": "A type of network protection to filter incoming network traffic.",
		"HONEYPOT": "A type of system to deliberately attract attacks. The system looks normal from an attacker's point of view but it is not used. Instead, it watches the actions of the attacker to gian an understanding of attack patterns."
	},
	GameProgress.Level.SOCIAL_ENGINEERING: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.", 
		"INTRUSION DETECTION SYSTEM": "IDS can be used to detect and alert on suspicious or malicious traffic on the network.", 
		"INTRUSION PREVENTION SYSTEM": "IPS can automatically block malicious traffic in real-time.",
		"HONEYPOT": "A type of system to deliberately attract attacks. The system looks normal from an attacker's point of view but it is not used. Instead, it watches the actions of the attacker to gian an understanding of attack patterns.",
		"FIREWALL": "A type of network protection to filter incoming network traffic."
	},
	GameProgress.Level.EoP: {
		"RANSOMWARE": "A type of malicious software that tries to gain access to a computer, fetch sensitive data and block access.", 
		"INTRUSION DETECTION SYSTEM": "IDS can be used to detect and alert on suspicious or malicious traffic on the network.", 
		"INTRUSION PREVENTION SYSTEM": "IPS can automatically block malicious traffic in real-time.",
		"HONEYPOT": "A type of system to deliberately attract attacks. The system looks normal from an attacker's point of view but it is not used. Instead, it watches the actions of the attacker to gian an understanding of attack patterns.",
		"FIREWALL": "A type of network protection to filter incoming network traffic."
	}
}

const CREATE_FIREWALL_VALUES = {
	GameProgress.Level.RANSOMWARE: {
		0: "Firewall created. You can go ahead and play around in the Network settings. However, please ensure that everything is enabled for it to function properly.",
		1: "Firewall already exists. Cannot create what's already there."
	}
}

const LISTEN_REQUESTS_VALUES = {
	GameProgress.Level.RANSOMWARE: {
		0: "Fetching of requests active. Please note that I only display requests if the firewall is properly enabled.",
		1: "Already listening to requests."
	}
}

const CHECK_CAPACITY_VALUES = {
	GameProgress.Level.DDoS: ["We're at 0%.", "We're at 10%.", "ITS OVER 9000%."]
}

const ENABLE_IDS_VALUES = {
	GameProgress.Level.DDoS: {
		0: "IDS enables. You're safe to proceed.",
		1: "IDS is already enabled ..."
	}
}

const CHECK_IDS_VALUES = {
	GameProgress.Level.SOCIAL_ENGINEERING: {
		0: "We have ONE Intruder in our system. Act swiftly!",
		1: "IDS has already been checked ... Please [color=red]DO SOMETHING[/color]."
	}
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
	if TerminalCommands.CHECK_IDS in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]CHECK IDS[/b]: Checks whether the [i]IDS[/i] has found an intruder."
	if TerminalCommands.CHECK_CAPACITY in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]CHECK CAPACITY[/b]: Displays the currenty request capacity of ours servers. The closer it is to 100%, the closer our system is to failure. If it's over 9000, all is lost."
	if TerminalCommands.TOGGLE_HARDMODE in SUPPORTED_COMMANDS[level]:
		help_text += "\n[b]TOGGLE HARDMODE[/b]: For developers who want the extra challenge. If enabled, increases the difficulty of challenges thrown your way. Can be disabled any time by re-entering the command."
	return help_text


func generate_list_terms(level: int) -> String:
	var term_list = "I can give you more information on the following terms:"
	for term in EXPLAIN_VALUES[level].keys():
		term_list += str("\n...[b]", term, "[/b]")
	return term_list
