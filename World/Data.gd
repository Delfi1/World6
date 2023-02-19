extends Node


var account_path = "user://Account.json"


var default_data = {
	"email" : "",
	"password" : "",
	"remember" : false,
	"AutoLogin" : false
}

var current_data = {
	
}

func reset_data():
	current_data.clear()
	current_data = default_data.duplicate(true)
	save_data(Data.account_path)


func save_data(path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_line(JSON.stringify(current_data))
	

func load_data(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	
	if not FileAccess.file_exists(path):
		return
	
	var data_json = JSON.parse_string(file.get_as_text())
	
	print(data_json)
	
	if data_json == null:
		reset_data()
		save_data(path)
		return
	
	current_data = data_json.duplicate(true)
	save_data(path)
