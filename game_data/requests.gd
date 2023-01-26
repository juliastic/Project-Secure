extends Node

enum Type {
	ALL,
	INTERNAL,
	EXTERNAL,
	HONEYPOT
}

const ALL_REQUESTS := {
	GameProgress.Level.RANSOMWARE: {
		0: ["10.2.3.4", "Fetch Updates", "user:Anna", "1"],
		1: ["10.2.3.5", "Access User Data", "user:Malvin", "1"],
		2: ["10.2.3.4", "Fetch Account Data", "external:Jacob", "1"],
		3: ["10.2.3.5", "Download Samples", "external:Dennis", "5"],
		4: ["10.2.3.5", "Test Honeypot Permissions", "user:Testuser", "30"],
		5: ["10.2.3.6", "Access Honeypot File", "user:asdf", "20"]
	}
}

const INTERNAL_REQUESTS := {
	GameProgress.Level.RANSOMWARE: {
		0: ["10.2.3.4", "Fetch Updates", "user:Anna", "1"],
		1: ["10.2.3.5", "Access User Data", "user:Malvin", "1"]
	}
}

const EXTERNAL_REQUESTS := {
	GameProgress.Level.RANSOMWARE: {
		2: ["10.2.3.4", "Fetch Account Data", "external:Jacob", "1"],
		3: ["10.2.3.5", "Download Samples", "external:Dennis", "5"]
	},
	GameProgress.Level.DDoS: {
		2: ["10.2.3.10", "Fetch Account Data", "external:asdfg", "100"],
		3: ["10.2.4.9", "Download Huge Database", "external:gjhls", "10"],
		4: ["10.2.4.10", "Request Update", "external:qwer", "200"],
		5: ["10.2.4.11", "Upload Update", "external:qertp", "200"]
	}
}

const HONEYPOT_REQUESTS := {
	GameProgress.Level.RANSOMWARE: {
		4: ["10.2.3.5", "Test Honeypot Permissions", "user:Testuser", "30"],
		5: ["10.2.3.6", "Access Honeypot File", "user:asdf", "20"]
	}
}

const REQUESTS := [ALL_REQUESTS, INTERNAL_REQUESTS, EXTERNAL_REQUESTS, HONEYPOT_REQUESTS]

var blocked_requests = {0: [], 1: [], 2: [], 3: []}

func reset_blocked_requests() -> void:
	blocked_requests = {0: [], 1: [], 2: [], 3: []}
