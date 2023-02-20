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
	$InfoMain/Info.text = Information()
	UpdateTimer.start(10)
	
	var collection : FirestoreCollection = Firebase.Firestore.collection('Users')
	collection.connect("get_document", _on_get_document)
	collection.connect("error", _on_document_error)
	
	collection.get_doc(Core.AuthInfo["localid"])
	
	
func _on_get_document(document):
	print("Succesfull get document!")
	Core.Data = document["doc_fields"]
	
	print(document)
	print(Core.Data)
	
	if bool(Core.Data["Admin"]):
		AdminMode()
	

@onready var UserDataPanel = $UserData
@onready var UserData = $UserData/Data

func AdminMode():
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


func Information():
	var stats = "Client Version: %s" % Core.Version
	
	if Core.ServerVer != null:
		stats = AddLine(stats, "Server Version: %s" % Core.ServerVer)
	
	var UUID = Core.AuthInfo["localid"]
	
	var Username = Core.AuthInfo["displayname"]
	
	stats = AddLine(stats, "UUID: %s" % UUID)
	
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
	$InfoMain/Info.text = Information()
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


