extends Node

var Version = "0.0.1.2"

var ServerVer = null

var AuthInfo = null

var Friends = {
	
}

var FriendInfo = {
	
}

var Data = null

var PckUrl = "https://github.com/Delfi1/World6/blob/master/Export/World.pck?raw=true"

var VerUrl = "https://raw.githubusercontent.com/Delfi1/World6/master/Export/Version.txt"

var FriendID = null

func _ready():
	Firebase.Firestore.collection('Users')

func _input(event):
	if event.is_action_pressed("F11"):
		if get_viewport().get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_viewport().get_window().mode = Window.MODE_MAXIMIZED
			return
		
		get_viewport().get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func VerMatch() -> bool:
	var ver = int(Version[0]) * 1000 + int(Version[2]) * 100 + int(Version[4]) * 10 + int(Version[6])
	
	var Sver = int(ServerVer[0]) * 1000 + int(ServerVer[2]) * 100 + int(ServerVer[4]) * 10 + int(ServerVer[6])
	print("%s, %s" % [ver, Sver])
	return Sver > ver


func Update(Request : HTTPRequest):
	if VerMatch():
		OS.alert("Find new version!")
		var path1 = OS.get_executable_path().get_base_dir() + "/World.pck"
		
		var path2 = OS.get_executable_path().get_base_dir() + "/World_Save.pck"
		
		DirAccess.rename_absolute(path1, path2)

		Request.set_download_file("World.pck")
		Request.request(PckUrl)


func OnFullscreen():
	if get_viewport().get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		return true
	else:
		return false


func Check_Update(Request : HTTPRequest):
	print("Check for updates...")
	Request.request(VerUrl)

func AddDocument(collection_id : String, document_id : String, dict : Dictionary):
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(collection_id)
	var add_task : FirestoreTask = firestore_collection.add(document_id, dict)
	await add_task


func UpdateDocument(collection_id : String, document_id : String, dict : Dictionary):
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(collection_id)
	var up_task : FirestoreTask = firestore_collection.update(document_id, dict)
	await up_task

func WithCreate():
	
	var CreateDict = {
		"Admin" = false,
		"Username" = AuthInfo["displayname"],
		"UUID" = AuthInfo["localid"],
	}
	
	AddDocument('Users', AuthInfo["localid"], CreateDict)
	AddDocument('Users/%s/Friends' % AuthInfo["localid"], "Friends", {})


func AddFriend(id : String):
	if id == AuthInfo["localid"]:
		return
	
	FriendID = id.strip_edges()
	IsFriended()
	
func IsFriended():
	var collection : FirestoreCollection = Firebase.Firestore.collection('Users/%s/Friends' % FriendID)
	collection.connect("get_document", CheckFriend)
	collection.connect("error", FriendError)
	
	
	collection.get_doc('Friends')

func FriendError(code, state, message):
	printerr(code)
	printerr(state)
	printerr(message)

func CheckFriend(document):
	if document["doc_fields"].has(AuthInfo["localid"]):
		print("Request already exist!")
	else:
		document["doc_fields"][AuthInfo["localid"]] = 3
		Friends[ToUUID(FriendID)] = 2
		UpdateDocument('Users/%s/Friends' % AuthInfo["localid"], 'Friends', Friends)
		UpdateDocument('Users/%s/Friends' % FriendID, 'Friends', document["doc_fields"])

func ToUUID(id : String):
	return "_" + id

func FromUUID(id : String):
	if id[0] == "_":
		id[0] = " "
	return(id.strip_edges())

func Change_Username(Username : String, Request : HTTPRequest):
		if len(Username) < 4:
			print("The name must be more than 4 characters long.")
			return
		
		
		var body = JSON.stringify({"idToken":AuthInfo["idtoken"], "displayName": Username, "returnSecureToken":false })
		var headers = ['Connect-Type: application/json']
		
		var url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAWHS5A70xTul-YML2ZWH7lntxeOxUn7XQ"
		
		var error = Request.request(url, headers, HTTPClient.METHOD_POST, body)
	
		if error != OK:
			printerr(error)


