extends Control

var firebaseConfig

# Called when the node enters the scene tree for the first time.
func _ready():
	loadConfigFromJSON()
	
	Firebase.set_config(firebaseConfig)
	Firebase.Auth.connect("sign_in_succeeded", self, "_on_sign_in_succeeded")
	Firebase.Auth.connect("response_error", self, "_on_response_error")
	Firebase.Auth.connect("user_data", self, "_on_user_data")

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


func _on_response_error(code, message):
	print("Response Error: " + str(code) + " | " + message)

func _on_AuthAnonymously_pressed():
	Firebase.Auth.sign_in_anonymously()

func _on_sign_in_succeeded(auth):
	print("Login Succeeded")
	print(auth)

func _on_GetUserData_pressed():
	Firebase.Auth.get_user_data()

func _on_user_data(userdata):
	print("User Data Recieved")
	print(userdata)

func _on_RefreshToken_pressed():
	Firebase.Auth.refresh_token()
