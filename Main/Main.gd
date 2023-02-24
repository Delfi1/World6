extends Control


func _ready():
	Core.WindowMinSize(Vector2i(1280, 720))
	_on_timer_timeout()
	CheckList()
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
	Friends.GetFriendsList(_on_get_friends, _on_get_friends_error)


@onready
var Friendlist = $Friends/PageList/ItemList


func CheckList():
	print("Friends List:")
	print(Friends.List)
	if len(Friends.List) < 1:
		print('Check...')
		await get_tree().create_timer(1.0).timeout
		CheckList()
		return
	print("Get")
	for i in range(len(Friends.List)):
		var friend = Friends.List[Friends.List.keys()[i]]
		print(friend)
		Friendlist.clear()
		Friendlist.add_item(friend["Name"])


func _on_get_friends(document):
	if not document["doc_fields"].has("friends"):
		return
	
	var friends = document["doc_fields"]["friends"]
	
	print(friends)
	
	Friends.List = friends


func _on_get_friends_error(code, state, message):
	printerr(code)
	printerr(state)
	printerr(message)


func _on_list_button_pressed():
	Friends.GetFriendsList(_on_get_friends, _on_get_friends_error)


func LoadFriendInfo(Friend : Dictionary, id : String):
	$FriendInfo/Tile.text = Friend["Name"]
	$FriendInfo/Text.text += "User ID: %s\n" % id
	$FriendInfo/Text.text += "[Debug] State: %s\n" % Friend["State"]


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	print(Friends.List.keys()[index])
	LoadFriendInfo(Friends.List[Friends.List.keys()[index]], Friends.List.keys()[index])
	$FriendInfo.visible = true
