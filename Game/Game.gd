extends Node3D

var actions = {
	
}

var objects = []

@onready var Neck = $Camera/Neck

@onready var Camera = $Camera/Neck/GlobalCamera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	$PauseScreen.visible = not IsCaptured()
	if event.is_action_pressed("ui_cancel"):
		if IsCaptured():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if event.is_action_pressed("Undo") and len(actions) != 0:
		if actions[len(actions)] == "Object":
			objects[len(objects)-1].queue_free()
			objects.erase(objects[len(objects)-1])
		
		actions.erase(len(actions))
	
	
	if event.is_action_pressed("Light"):
		var Light = preload("res://Game/Objects/light.tscn")
		var rot = Vector3(Camera.rotation.x, Neck.rotation.y, 0)
		
		var pos = Camera.global_transform.origin
		
		summon(Light, pos, rot)

func summon(scene : PackedScene, pos : Vector3, rot := Vector3(0, 0, 0)):
	var object = scene.instantiate()
	add_child(object)
	object.position = pos
	object.rotation = rot
	AddObject(object)



func AddObject(object : Node):
	actions[len(actions) + 1] = "Object"
	objects.append(object)


func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
