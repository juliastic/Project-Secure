extends Node

const INCOMING_REQUESTS := {GameProgress.Level.RANSOMWARE: {
	0: ["10.2.3.4", "Fetch Updates", "user:Anna", "1"],
	1: ["10.2.3.5", "Access Honeypot File", "user:Malvin", "20"]
	}
}

var blocked_requests = []
