extends HTTPRequest
class_name FirebaseFirestore

signal response_error(module, code, message)
signal get_documents_response(data)

var config
var Auth : FirebaseAuth
var callbackBAD : FuncRef

const list_documents_url = "https://firestore.googleapis.com/v1beta1/projects/food-chain-53159/databases/#database#/documents/#path#/"

func _ready():
	connect("request_completed", self, "_on_firestore_request_completed")

func get_documents(database, path, callback : FuncRef):
	var data = ""
	var url = list_documents_url.replace("#database#", database).replace("#path#", path)
	callbackBAD = callback
	request(url, ["Authorization: Bearer " + Auth.auth.idtoken , "Content-Type: application/json"], true, HTTPClient.METHOD_GET, "")

func _on_firestore_request_completed(result, response_code, headers, body):
	var body_string = body.get_string_from_utf8()
	var json_result = JSON.parse(body_string)
	if json_result.error != OK:
		print_debug("Error while parsing body json")
		return
	
	var res = json_result.result
	if response_code == HTTPClient.RESPONSE_OK:
		callbackBAD.call_func(res)
		#emit_signal("get_documents_response", res)
	else:
		emit_signal("response_error", "Firestore", res.error.code, res.error.message)
