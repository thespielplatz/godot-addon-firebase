extends HTTPRequest
class_name FirebaseAuth

signal login_succeeded(auth)
signal login_failed(code, message)

var config = {}
var signin_anonymously_request_url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="
var refresh_request_url = "https://securetoken.googleapis.com/v1/token?key="

const RESPONSE_SIGNIN   = "identitytoolkit#VerifyPasswordResponse"
const RESPONSE_SIGNUP   = "identitytoolkit#SignupNewUserResponse"
const RESPONSE_USERDATA = "identitytoolkit#GetAccountInfoResponse"

var needs_refresh = false
var auth = null

func _ready():
	connect("request_completed", self, "_on_FirebaseAuth_request_completed")

func set_config(_config):
	config = _config

func login_anonymously():
	var data = {
		"returnSecureToken": true
	}
	var url = signin_anonymously_request_url + config.apiKey
	request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(data))
	pass

# This function is called whenever there is an authentication request to Firebase
# On an error, this function with emit the signal 'login_failed' and print the error to the console
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
			begin_refresh_countdown()
		else:
			match res.kind:
				RESPONSE_SIGNIN, RESPONSE_SIGNUP:
					auth = _get_auth_from_response(res)
					emit_signal("login_succeeded", auth)
					# TODO: CONTINUE HERE
					#begin_refresh_countdown()
					
				# RESPONSE_USERDATA:
				#	var userdata = FirebaseUserData.new(res.users[0])
				#	emit_signal("userdata_received", userdata)
	else:
		if (res.error.message == "ADMIN_ONLY_OPERATION"):
			print("If you are trying to Auth Anonymously, check the firebase permissions")

		# error message would be INVALID_EMAIL, EMAIL_NOT_FOUND, INVALID_PASSWORD, USER_DISABLED or WEAK_PASSWORD
		emit_signal("login_failed", res.error.code, res.error.message)
		
# Function is called when a new token is issued to a user. The function will yield until the token has expired, and then request a new one.
func begin_refresh_countdown():
	var refresh_token = null
	var expires_in = 1000
	auth = _get_auth_from_response(auth)
	if auth.has("refreshToken"):
		refresh_token = auth.refreshToken
		expires_in = auth.expiresIn
	elif auth.has("refresh_token"):
		refresh_token = auth.refresh_token
		expires_in = auth.expires_in
	needs_refresh = true
	yield(get_tree().create_timer(float(expires_in)), "timeout")
	#refresh_request_body.refresh_token = refresh_token
	#request(refresh_request_url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(refresh_request_body))
		
# This function is used to make all keys lowercase
# This is only used to cut down on processing errors from Firebase
# This is due to Google have inconsistencies in the API that we are trying to fix
func _get_auth_from_response(auth_result):
	var data = {}
	for key in auth_result.keys():
		data[key.replace("_", "").to_lower()] = auth_result[key]
	return data
