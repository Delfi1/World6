extends Control


func _ready():
	Core.WindowMinSize(Vector2i(1280, 720))
	CheckUpdate()
	CheckList()
	Friends.GetFriendsList(_on_get_friends, _on_get_friends_error)
	$System/Timer.start(30)


func _input(event):
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
		print(result, headers)
		return
	
	OS.alert("New version was installed! Stopping...", "Updater")
	get_tree().quit()



func _on_timer_timeout():
	CheckUpdate()
	CheckList()


@onready
var Friendlist = $Friends/PageList/ItemList


func CheckList():
	print("Friends List:")
	print(Friends.List)
	if len(Friends.List) < 1:
		return
	
	for i in range(len(Friends.List)):
		Friendlist.add_item(Friends.List[Friends.List.keys()[i]])


func _on_get_friends(document):
	if not document["doc_fields"].has("friends"):
		return
	
	Friends.List = document["doc_fields"]["friends"]
	
	Friends.DisconnectFriends('Users', _on_get_friends, _on_get_friends_error)


func _on_get_friends_error(code, state, message):
	printerr(code)
	printerr(state)
	printerr(message)
	
	Friends.DisconnectFriends('Users', _on_get_friends, _on_get_friends_error)
	
