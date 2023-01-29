extends Node

var rng = RandomNumberGenerator.new()

var requests := {
		0: ["10.2.3.4", "Fetch Updates", "user:Anna", "INTERNAL", "1"],
		1: ["10.2.3.5", "Access User Data", "user:Malvin", "INTERNAL", "1"],
		2: ["10.2.3.4", "Fetch Account Data", "external:Jacob", "EXTERNAL", "1"],
		3: ["10.2.3.5", "Download Samples", "external:Dennis", "EXTERNAL", "5"],
		4: ["10.2.3.5", "Test Honeypot Permissions", "user:Testuser", "HONEYPOT", "30"],
		5: ["10.2.3.6", "Access Honeypot File", "user:asdf", "HONEYPOT", "20"]
}

const malicious_requests = ["5"]

var blocked_requests = []

func reset_blocked_requests() -> void:
	blocked_requests = []


#TODO: generate random set of names, etc
func generate_requests() -> void:
	var request_types = ["INTERNAL", "EXTERNAL", "HONEYPOT"]
	# if at a specific index -> insert request manually since they'll be the score ones
	for i in range(100):
		rng.randomize()
		requests[i] = [str("10.0.0.", rng.randi_range(0, 100)), "RANDOM", "more random", request_types[rng.randi_range(0, 2)], rng.randi_range(1, 100)]
