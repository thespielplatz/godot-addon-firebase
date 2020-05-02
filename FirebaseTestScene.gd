extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var firebaseConfig

# Called when the node enters the scene tree for the first time.
func _ready():
	loadConfigFromJSON()
	
	Firebase.set_config(firebaseConfig)
	
	pass # Replace with function body.

func loadConfigFromJSON():
	var file = File.new()
	var err = file.open("res://firebase-config.json", file.READ)
	if err != OK:
		print("Custom firebase-config not found / Fallback to default")
		err = file.open("res://firebase-config-default.json", file.READ)
		
	if err != OK:
		print("No Firebase Config File Found")
		return

	var json = file.get_as_text()
	firebaseConfig = parse_json(json)
	print("Loaded Firebase Config")
	print(firebaseConfig)

func _on_AuthAnonymously_pressed():
	Firebase.Auth.connect("login_succeeded", self, "_on_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_on_login_failed")
	Firebase.Auth.login_anonymously()

func _on_login_succeeded(auth):
	print("Login Succeeded")
	
func _on_login_failed(code, message):
	print("Login Failed Code: " + str(code) + " | " + message)
