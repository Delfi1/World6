extends Node3D

func _input(event):
	$HUD/Control.visible = not IsCaptured()
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
