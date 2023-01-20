extends Node

const INTRO_DIALOGUE := [
	">> Hello ... nice to see meet you. I'm guessing this is your first day? [i]Press ENTER or RETURN to continue[/i]",
	"\n>> Either way: I'm Bob, your new partner.",
	"\n>> Your job is to support the company with defending against attacks on our system. You'll be using this computer as your working device.",
	str("\n> We've been regularly receiving threats ever since our CEO tweeted about a random celebrity. Don't ask me, I can't understand human emotions.",
		"Such a waste of time when you could be working. Anyway, I'll be here to support you and lend you my expertise and knowledge.",
		"You'll be focusing on different types of threats on different days. Unfortunately I don't have a body yet so I'll be stuck in this terminal for the time being."),
	str("\n>> The terminal acts as the main interaction point between you and me.",
		"Interacting with the terminal is straight forward. Enter any of the available commands to trigger certain actions.",
		"The commands might seem a bit meta sometimes, but trust me - it's good that they are.",
		"This way I always know what you are doing. If you need any guidance, enter [i]HELP[/i]."),
	str("\n>> Your current tasks are displayed on the bottom right corner of the screen.",
	"Entering [i]BACKSTORY[/i] should give you an idea of the state of our current system.",
	"Today will start relatively slow. Your goal is to get acquainted with the system and play around.")
]

const CONSOLE_DIALOGUE := {
	"random_messages": ["Test", "Another"],
	"levels": {
		1: {
			"GRAB COFFEE": "... finally."
		},
		2: {
			"GRAB COFFEE": "...\n...\n...\n[i]You've found a USB stick. A colleague joins you and asks you about this USB-stick. Before you can say anything, they plug it into their computer ... oh no ...[/i]"
		}
	}
}
