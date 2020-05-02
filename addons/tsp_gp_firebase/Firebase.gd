extends Node

const FirebaseAuth = preload("res://addons/tsp_gp_firebase/FirebaseAuth.gd")
onready var Auth : FirebaseAuth = FirebaseAuth.new()
onready var Firestore = Node.new()

onready var config = {
	"apiKey": "",
	"authDomain": "",
	"databaseURL": "",
	"projectId": "",
	"storageBucket": "",
	"messagingSenderId": "",
	"appId": "",
  }

func _ready():
	Auth.set_config(config)
	add_child(Auth)
	
	
	#Firestore.set_script(preload("res://addons/tsp_gp_firebase/FirebaseFirestore.gd"))
	#add_child(Firestore)
	#Auth.connect("login_succeeded", Firestore, "_on_FirebaseAuth_login_succeeded")

func set_config(_config : Dictionary):
	config = _config
	Auth.set_config(config)
	#Firestore.set_config(config)
 
