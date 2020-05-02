tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Firebase", "res://addons/tsp_gp_firebase/Firebase.gd")

func _exit_tree():
	remove_autoload_singleton("Firebase")
