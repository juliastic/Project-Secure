extends Node

var rng = RandomNumberGenerator.new()

var requests := {
		0: ["10.2.3.4", "Fetch Updates", "user:Anna", "INTERNAL", "1"],
		1: ["10.2.3.5", "Access User Data", "user:Malvin", "INTERNAL", "1"],
		2: ["10.2.3.4", "Fetch Account Data", "external:Jacob", "EXTERNAL", "1"],
		3: ["10.2.3.4", "Download Account Data", "external:Anna", "EXTERNAL", "1"],
		4: ["10.2.3.10", "Update Account Data", "external:Julia", "EXTERNAL", "1"],
		5: ["10.2.3.5", "Download Samples", "external:Dennis", "EXTERNAL", "5"],
		6: ["10.2.3.5", "Test Honeypot Permissions", "user:Testuser", "HONEYPOT", "30"],
		7: ["10.2.3.6", "Access Honeypot File", "user:asdf", "HONEYPOT", "20"],
		8: ["10.2.3.1", "Do Full-Load Server tests", "user:testuser1", "INTERNAL", "20"],
		9: ["10.2.3.1", "Do Low-Load Server tests", "user:testuser2", "INTERNAL", "100"]
}

const MALICIOUS_REQUESTS = ["7"]

var blocked_requests = []
