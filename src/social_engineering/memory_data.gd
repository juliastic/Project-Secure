extends Node

enum ActionType {
	PERSON,
	ACTION
}

const CARD_DATA = preload("card_data.gd")

const MALICIOUS_PAIR_IDS = [1, 2]

var cards = [
	CARD_DATA.new(0, ActionType.PERSON, "Marcus, HR"),
	CARD_DATA.new(0, ActionType.ACTION, "Checked Payroll Slips"),
	CARD_DATA.new(1, ActionType.PERSON, "Sophie, Accounting"),
	CARD_DATA.new(1, ActionType.ACTION, "Verified Payments"),
	CARD_DATA.new(2, ActionType.PERSON, "Anna, Developer"),
	CARD_DATA.new(2, ActionType.ACTION, "Updated Database Entry"),
	CARD_DATA.new(3, ActionType.PERSON, "Mark, Service Desk"),
	CARD_DATA.new(3, ActionType.ACTION, "Accessed Desktop of Anna"),
	CARD_DATA.new(4, ActionType.PERSON, "Jacob, Marketing"),
	CARD_DATA.new(4, ActionType.ACTION, "Fetched Promotional Assets"),
	CARD_DATA.new(5, ActionType.PERSON, "Jennifer, Front Desk"),
	CARD_DATA.new(5, ActionType.ACTION, "Booked Flights"),
	CARD_DATA.new(9, ActionType.PERSON, "Julia, HR"),
	CARD_DATA.new(10, ActionType.ACTION, "Downloaded and deleted all database entries")
]
