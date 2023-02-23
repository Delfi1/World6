extends Node

var AccountPath = "user://Account.json"

var DefaultAccount = {
	"email" : "",
	"password" : "",
	"remember" : false
}


func SaveData(path : String, data : Dictionary):
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_line(JSON.stringify(data))


func LoadData(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		
		var data = JSON.parse_string(file.get_as_text())
		if data != null:
			return data

