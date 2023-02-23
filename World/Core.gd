extends Node

var PckUrl = "https://github.com/Delfi1/World6/blob/master/Export/World.pck?raw=true"

var VerUrl = "https://raw.githubusercontent.com/Delfi1/World6/master/Export/Version.txt"

var Version = "0.0.1.6"

var Server = null

var UserData = {
	"Name" : null,
	"Email" : null,
	"UUID" : null,
	"registered" : false
}


func IsFullscreen():
	return get_viewport().get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN


func _input(event):
	if event.is_action_pressed("F11"):
		print("F11")
		if IsFullscreen():
			get_viewport().get_window().mode = Window.MODE_MAXIMIZED
		else:
			get_viewport().get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN

## @args collection_id
## @args document_id
## @args function
## @args error_function
func GetDocument(collection_id, document_id, function : Callable, error : Callable):
	var collection : FirestoreCollection = Firebase.Firestore.collection(collection_id)
	if collection.is_connected("get_document", function):
		collection.disconnect("get_document", function)
		collection.disconnect("error", error)
	collection.connect("get_document", function)
	collection.connect("error", error)
	collection.get_doc(document_id)


func AddDocument(collection_id, document_id, dict : Dictionary):
	var collection : FirestoreCollection = Firebase.Firestore.collection(collection_id)
	var add_task : FirestoreTask = collection.add(document_id, dict)
	await add_task


func WindowMinSize(size : Vector2i):
	get_viewport().get_window().min_size = size


func CheckVersion():
	var ver = int(Version[0]) * 1000 + int(Version[2]) * 100 + int(Version[4]) * 10 + int(Version[6])
	
	var sver = int(Server[0]) * 1000 + int(Server[2]) * 100 + int(Server[4]) * 10 + int(Server[6])
	
	return ver < sver


func Update(Request : HTTPRequest):
	OS.alert("Find new version!")
	
	Request.set_download_file("World.pck")
	Request.request(PckUrl)

