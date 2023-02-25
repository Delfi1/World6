extends Node3D

var objects = []

@onready var Neck = $Camera/Neck

@onready var Camera = $Camera/Neck/GlobalCamera

func _input(event):
	$PauseScreen.visible = not IsCaptured()
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("Undo") and len(objects) != 0:
		print(len(objects))
		objects[len(objects)-1].queue_free()
		objects.erase(objects[len(objects)-1])
	
	if event.is_action_pressed("Light"):
		var Light = preload("res://Game/Objects/light.tscn").instantiate()
		get_parent().add_child(Light)
		Light.rotation.x = Camera.rotation.x
		Light.rotation.y = Neck.rotation.y
		objects.append(Light)

func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
