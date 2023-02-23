extends Control

@onready
var EmailText = $SignBox/Main/EmailPanel/EmailText

@onready
var PasswordText = $SignBox/Main/PasswordPanel/PasswordText

func _ready():
	Firebase.Auth.connect("login_succeeded", _on_login_succeeded)
	Firebase.Auth.connect("login_failed", _on_login_failed)
	
	var data = Data.LoadData()
	
	

func Login():
	var email = EmailText.text.strip_edges()
	
	var password = PasswordText.text.strip_edges()
	
	Firebase.Auth.login_with_email_and_password(email, password)


func _on_login_succeeded(auth):
	Core.UserData["Name"] = auth["displayname"]
	Core.UserData["Email"] = auth["email"]
	Core.UserData["UUID"] = auth["localid"]
	Core.UserData["registered"] = auth["registered"]
	
	if auth["registered"]:
		get_tree().change_scene_to_file("res://Main/Main.tscn")
	

func _on_login_failed(error_code, message):
	OS.alert(message, "Error " + str(error_code))
