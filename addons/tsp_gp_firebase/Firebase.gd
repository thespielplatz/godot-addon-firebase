extends Node

var FirebaseAuth = preload("res://addons/tsp_gp_firebase/FirebaseAuth.gd")
var FirebaseUser = preload("res://addons/tsp_gp_firebase/FirebaseUser.gd")
var FirebaseFirestore = preload("res://addons/tsp_gp_firebase/FirebaseFirestore.gd")

onready var Auth : FirebaseAuth = FirebaseAuth.new()
onready var Firestore : FirebaseFirestore = FirebaseFirestore.new()

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
	
	Firestore.Auth = Auth	
	add_child(Firestore)

func set_config(_config : Dictionary):
	config = _config
	Auth.set_config(config)
	Firestore.config = config
