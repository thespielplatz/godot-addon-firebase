extends HTTPRequest
class_name FirebaseAuth

signal response_error(code, message)

signal sign_in_succeeded(auth)
signal user_data(user)

var config

const signin_anonymously_request_url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="
const get_user_data_url = "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key="
const refresh_request_url = "https://securetoken.googleapis.com/v1/token?key="

const RESPONSE_SIGNIN   = "identitytoolkit#VerifyPasswordResponse"
const RESPONSE_SIGNUP   = "identitytoolkit#SignupNewUserResponse"
const RESPONSE_USERDATA = "identitytoolkit#GetAccountInfoResponse"

var refresh_running = false
var auth = {
	"idtoken" : ""
}

func _ready():
	connect("request_completed", self, "_on_FirebaseAuth_request_completed")

func set_config(_config):
	config = _config

func sign_in_anonymously():
	var data = {
		"returnSecureToken": true
	}
	var url = signin_anonymously_request_url + config.apiKey
	request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(data))

func get_user_data():
	var data = {
		"idToken": auth.idtoken
	}
	var url = get_user_data_url + config.apiKey
	request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(data))

# This function is called whenever there is an authentication request to Firebase
func _on_FirebaseAuth_request_completed(result, response_code, headers, body):
	var body_string = body.get_string_from_utf8()
	var json_result = JSON.parse(body_string)
	if json_result.error != OK:
		print_debug("Error while parsing body json")
		return
	
	var res = json_result.result
	if response_code == HTTPClient.RESPONSE_OK:
		if not res.has("kind"):
			auth = _get_auth_from_response(res)
			start_refresh_countdown()
			
		else:
			match res.kind:
				RESPONSE_SIGNIN, RESPONSE_SIGNUP:
					auth = _get_auth_from_response(res)
					start_refresh_countdown()
					emit_signal("sign_in_succeeded", auth)
					
				RESPONSE_USERDATA:
					var user : FirebaseUser = FirebaseUser.new(res.users[0])
					emit_signal("user_data", user)
	else:
		if (res.error.message == "ADMIN_ONLY_OPERATION"):
			print("If you are trying to Auth Anonymously, check the firebase permissions")

		# error message would be INVALID_EMAIL, EMAIL_NOT_FOUND, INVALID_PASSWORD, USER_DISABLED or WEAK_PASSWORD
		emit_signal("response_error", res.error.code, res.error.message)
		
# Function is called when a new token is issued to a user. The function will yield until the token has expired, and then request a new one.
func start_refresh_countdown():
	if refresh_running:
		return
		
	refresh_running = true
	var expires_in = 1000
	if auth.has("expiresIn"):
		expires_in = auth.expiresIn
	elif auth.has("expires_in"):
		expires_in = auth.expires_in
	elif auth.has("expiresin"):
		expires_in = auth.expiresin
		
	#var thread = Thread.new()
	#thread.start(self, "wait_until_refresh", expires_in)
	#thread.wait_to_finish()
	#func wait_until_refresh(expires_in):
	yield(get_tree().create_timer(float(expires_in)), "timeout")
	refresh_token()
	
func refresh_token():
	print_debug("Refreshing Token")
	refresh_running = false
	
	var refresh_token = null
	if auth.has("refreshToken"):
		refresh_token = auth.refreshToken
	elif auth.has("refresh_token"):
		refresh_token = auth.refresh_token
	elif auth.has("refreshtoken"):
		refresh_token = auth.refreshtoken
		
	var data = {
		"refresh_token": refresh_token,
		"grant_type" : "refresh_token"
	}
	var url = refresh_request_url + config.apiKey
	request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(data))
		
# This function is used to make all keys lowercase
# This is only used to cut down on processing errors from Firebase
# This is due to Google have inconsistencies in the API that we are trying to fix
func _get_auth_from_response(auth_result):
	var data = {}
	for key in auth_result.keys():
		data[key.replace("_", "").to_lower()] = auth_result[key]
	return data
