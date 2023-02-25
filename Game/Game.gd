extends Node3D

var actions = {
	
}

var objects = []

@onready var Neck = $Camera/Neck

@onready var Camera = $Camera/Neck/GlobalCamera

func _ready():
	TreeList()
	

var RightButtonPressed = false

func _unhandled_input(event):
	if IsCaptured():
		if event is InputEventMouseMotion:
			Neck.rotate_y(-event.relative.x * 0.005)
			Camera.rotate_x(-event.relative.y * 0.005)
			Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():  # Mouse button down.
			RightButtonPressed = true
		elif not event.is_pressed():  # Mouse button released.
			RightButtonPressed = false
	
	

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		$HUD.visible = not $HUD.visible
	
	if event.is_action_pressed("Undo") and len(actions) != 0:
		if actions[len(actions)] == "Object":
			objects[len(objects)-1].queue_free()
			objects.erase(objects[len(objects)-1])
			TreeList()
		
		actions.erase(len(actions))
		TreeList()
	
	if event.is_action_pressed("Light"):
		var Light = preload("res://Game/Objects/light.tscn")
		var rot = Vector3(Camera.rotation.x, Neck.rotation.y, 0)
		
		var pos = Camera.global_transform.origin
		
		summon(Light, pos, rot)
		TreeList()


func _process(delta):
	if RightButtonPressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		TreeList()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if SelectedObj != null:
		ObjectInfo(SelectedObj)


func summon(scene : PackedScene, pos : Vector3, rot := Vector3(0, 0, 0)):
	var object = scene.instantiate()
	
	var name = object.name
	
	var add = 2
	
	while true:
		if self.has_node(NodePath(object.name)):
			object.name = name + str(add)
			add += 1
		else:
			break
	
	
	add_child(object)
	object.position = pos
	object.rotation = rot
	AddObject(object)
	TreeList()


func AddObject(object : Node):
	actions[len(actions) + 1] = "Object"
	objects.append(object)


func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func TreeList():
	$HUD/Tree/List.clear()
	for N in self.get_children():
		if N.get_name() == "HUD" or N.get_name() == "Trash":
			continue
		$HUD/Tree/List.add_item(N.get_name())


var SelectedObj = null


func _on_list_item_clicked(index, at_position, mouse_button_index):
	index += 2
	
	SelectedObj = self.get_child(index)


func ObjectInfo(object : Node):
	var pos_x = snapped(object.position.x, 0.01)
	var pos_y = snapped(object.position.y, 0.01)
	var pos_z = snapped(object.position.z, 0.01)
	
	$HUD/Object/Position/x.text = str(pos_x)
	$HUD/Object/Position/y.text = str(pos_y)
	$HUD/Object/Position/z.text = str(pos_z)
	
