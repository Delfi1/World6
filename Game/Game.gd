extends Node3D

var actions = {
	
}

var objects = []

@onready var Neck = $Camera/Neck

@onready var Camera = $Camera/Neck/GlobalCamera

func _input(event):
	$PauseScreen.visible = not IsCaptured()
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if event.is_action_pressed("Undo") and len(actions) != 0:
		if actions[len(actions)] == "Object":
			objects[len(objects)-1].queue_free()
			objects.erase(objects[len(objects)-1])
		
		actions.erase(len(actions))
	
	
	if event.is_action_pressed("Light"):
		var Light = preload("res://Game/Objects/light.tscn").instantiate()
		add_child(Light)
		Light.rotation.x = Camera.rotation.x
		Light.rotation.y = Neck.rotation.y
		Light.position = Camera.global_transform.origin
		AddObject(Light)

#func summon(object : PackedScene):
	#add_child()



func AddObject(object : Node):
	actions[len(actions) + 1] = "Object"
	objects.append(object)


func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
