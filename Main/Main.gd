extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GetUserData()
	Core.WindowMinSize(Vector2i(1280, 720))
	_on_timer_timeout()
	$System/Timer.start(30)



func GetUserData():
	Core.GetDocument("Users", Core.UserData["UUID"], GetDataSuccess, GetDataError)


func GetDataSuccess(document):
	print(document)
	var data = document["doc_fields"]
	Core.UserData["Admin"] = data["Admin"]
	Admin()

func GetDataError(code, status, message):
	printerr(code)
	printerr(status)
	printerr(message)


func Admin():
	if not Core.UserData["Admin"]:
		return
	
	$Tile.text = "World [Admin mode]"
	$CreateRoom.visible = true
	$CreateRoom.disabled = false
	
	$Test.visible = true
	$Test.disabled = false

func _input(event):
	if event == InputEventKey:
		pass
	$ExitButton.visible = Core.IsFullscreen()


func _on_exit_button_pressed():
	get_tree().quit()


func CheckUpdate():
	$System/CheckRequest.request(Core.VerUrl)


func _on_check_request(result, response_code, headers, body):
	if response_code != 200:
		print(result, headers)
		return
	
	var response = body.get_string_from_utf8()
	
	Core.Server = response.strip_edges()
	
	print(Core.Version)
	print(Core.Server)
	
	if Core.CheckVersion():
		Core.Update($System/UpdateRequest)


func _on_update_request(result, response_code, headers, body):
	if response_code != 200:
		print(result, headers, body)
		return
	
	OS.alert("New version was installed! Stopping...", "Updater")
	get_tree().quit()


func _on_timer_timeout():
	CheckUpdate()
	Admin()


func _on_create_room_pressed():
	get_tree().change_scene_to_file("res://Lobby/Create.tscn")


func _on_test_pressed():
	get_tree().change_scene_to_file("res://Game/Game.tscn")
