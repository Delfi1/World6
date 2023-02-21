extends Control

@onready
var ExitButton = $Exit

@onready
var UpdateTimer = $System/Timer

@onready
var CheckVersion = $System/CheckVersion

@onready
var UpdateVersion = $System/UpdateVersion

func _ready():
	$InfoMain/Info.text = "Client Version: %s" % Core.Version
	
	if Core.ServerVer != null:
		$InfoMain/Info.text = AddLine($InfoMain/Info.text, "Server Version: %s" % Core.ServerVer)
	
	$InfoMain/Info.text = AddLine($InfoMain/Info.text, Information(Core.AuthInfo))
	UpdateTimer.start(10)
	
	print("_1_2_3")
	print(Core.FromUUID("_1_2_3"))
	Get_User_Info()
	Get_User_Friends()
	
	
	

func Get_User_Info():
	var collection : FirestoreCollection = Firebase.Firestore.collection('Users')
	collection.connect("get_document", _on_get_UserInfo)
	collection.connect("error", _on_document_error)
	
	collection.get_doc(Core.AuthInfo["localid"])

func Get_User_Friends():
	var collection : FirestoreCollection = Firebase.Firestore.collection('Users/%s/Friends' % Core.AuthInfo["localid"])
	collection.connect("get_document", _on_get_UserFriends)
	collection.connect("error", _on_document_error)
	
	collection.get_doc('Friends')


func _on_get_UserInfo(document):
	if Core.Data != null:
		return
	print("Succesfull get document!")
	Core.Data = document["doc_fields"]
	
	print(document)
	print(Core.Data)
	
	if bool(Core.Data["Admin"]):
		AdminMode()
	

func _on_get_UserFriends(document):
	print(document)
	Core.Friends = document["doc_fields"]
	LoadFriendList()

@onready var FriendsList = $Friends/FriendsList

func LoadFriendList():
	for j in range(len(Core.Friends)):
		if int(Core.Friends[Core.Friends.keys()[j]]) == 0:
			Core.Friends[Core.Friends.keys()[j]].erase()
	
	for i in range(len(Core.Friends)):
		FriendsList.add_item(str(i+1) + ". " + Core.Friends.keys()[i])


@onready var UserDataPanel = $UserData
@onready var UserData = $UserData/Data

func AdminMode():
	print("ADMIN")
	if not bool(Core.Data["Admin"]):
		return
	
	UserDataPanel.visible = true
	UserData.text = "Admin: %s\nUsername: %s \n UUID: %s" % [Core.Data["Admin"], Core.Data["Username"], Core.Data["UUID"]]

func _on_document_error(code, status, message):
	printerr(code)
	printerr(status)
	printerr(message)

func _on_task_finished():
	print("Task finished")
	pass

func _input(event):
	if event.is_action_pressed("escape"):
		_on_exit_pressed()
	
	ExitButton.visible = Core.OnFullscreen()


func Information(Info : Dictionary):
	var UUID
	if Info.has("localid"):
		UUID = Info["localid"]
	else:
		UUID = Info["UUID"]
	
	var Username
	if Info.has("displayname"):
		Username = Info["displayname"]
	else:
		Username = Info["Username"]
	
	var stats = "UUID: %s" % UUID
	
	stats = AddLine(stats, "Username: %s" % Username)
	
	return stats


func AddLine(text, line):
	return line + "\n" + text


func _on_exit_pressed():
	get_tree().quit()


func _on_timer_timeout():
	UpdateTimer.stop()
	Core.Check_Update(CheckVersion)
	UpdateTimer.start(60)


func _on_check_version_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	
	if response_code != 200:
		print(result, headers)
		return
	
	Core.ServerVer = response.strip_edges()
	$InfoMain/Info.text = "Client Version: %s" % Core.Version
	
	if Core.ServerVer != null:
		$InfoMain/Info.text = AddLine($InfoMain/Info.text, "Server Version: %s" % Core.ServerVer)
	
	$InfoMain/Info.text = AddLine($InfoMain/Info.text, Information(Core.AuthInfo))
	
	Core.Update(UpdateVersion)


func _on_update_version_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print(result, headers, body)
		OS.alert("Error " + response_code)
		var path1 = OS.get_executable_path().get_base_dir() + "\\World.pck"
		var path2 = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
		
		DirAccess.remove_absolute(path1)
		
		DirAccess.rename_absolute(path2, path1)
		return
	
	var path = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
	
	DirAccess.remove_absolute(path)
	
	OS.alert("Update was installed! Stopping...", "Updater")
	get_tree().quit()


func _on_friends_list_item_clicked(index, at_position, mouse_button_index):
	var id = Core.FromUUID(Core.Friends.keys()[index])
	Core.FriendID = id
	
	var collection : FirestoreCollection = Firebase.Firestore.collection('Users')
	collection.connect("get_document", _on_get_friend)
	#collection.connect("error", _on_get_friend_error)
	
	collection.get_doc(id)

@onready var FriendInfo = $FriendInfo/Information

@onready var AcceptPanel = $FriendInfo/AcceptPanel

func _on_get_friend(document):
	FriendInfo.get_parent().visible = true
	Core.FriendInfo = document["doc_fields"]
	FriendInfo.text = Information(Core.FriendInfo)
	var state = Core.Friends[Core.ToUUID(Core.FriendID)]
	
	match state:
		1:
			#Friends
			AcceptPanel.visible = false
		2:
			#Waiting...
			AcceptPanel.visible = false
		3:
			#Accept/Decline
			AcceptPanel.visible = true

func _on_friends_list_empty_clicked(at_position, mouse_button_index):
	FriendInfo.get_parent().visible = false


func _on_accept_pressed():
	Core.ChangeFriendState(Core.FriendID, 1)
	AcceptPanel.visible = false


func _on_ignore_pressed():
	Core.ChangeFriendState(Core.FriendID, 0)
	AcceptPanel.visible = false


