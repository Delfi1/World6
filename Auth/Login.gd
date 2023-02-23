extends Control

@onready
var EmailText = $SignBox/Main/EmailPanel/EmailText

@onready
var PasswordText = $SignBox/Main/PasswordPanel/PasswordText

@onready
var RememberButton = $SignBox/Main/Remember


@onready var data = Data.LoadData(Data.AccountPath)


func _ready():
	Firebase.Auth.connect("login_succeeded", _on_login_succeeded)
	Firebase.Auth.connect("login_failed", _on_login_failed)
	
	Core.WindowMinSize(Vector2i(456, 704))
	
	if data.has("email"):
		if not data["remember"]:
			Data.SaveData(Data.AccountPath, Data.DefaultAccount)
			return
		
		RememberButton.button_pressed = data["remember"]
		
		EmailText.text = data["email"]
		PasswordText.text = data["password"]


func Login():
	var email = EmailText.text.strip_edges()
	
	var password = PasswordText.text.strip_edges()
	
	data["email"] = EmailText.text.strip_edges()
	data["password"] = PasswordText.text.strip_edges()
	data["remember"] = RememberButton.button_pressed
	
	Firebase.Auth.login_with_email_and_password(email, password)


func _on_login_succeeded(auth):
	Core.UserData["Admin"] = false
	Core.UserData["Name"] = auth["displayname"]
	Core.UserData["Email"] = auth["email"]
	Core.UserData["UUID"] = auth["localid"]
	
	if auth["registered"]:
		Data.SaveData(Data.AccountPath, data)
		get_tree().change_scene_to_file("res://Main/Main.tscn")
		Core.AddDocument('Users', Core.UserData["UUID"], Core.UserData)


func _on_login_failed(error_code, message):
	OS.alert(message, "Error " + str(error_code))
