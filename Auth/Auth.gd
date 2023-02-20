extends Control


@onready var LoginPage = $Login/Background


@onready var SignUpPage = $SignUp/Background


func _ready():
	Firebase.Auth.connect("login_succeeded", _on_FirebaseAuth_login_succeeded)
	Firebase.Auth.connect("signup_succeeded", _on_FirebaseAuth_siginUp_succeeded)
	Firebase.Auth.connect("login_failed", on_login_failed)
	#Firebase.Auth.connect("signup_failed", "on_signup_failed")

	Data.load_data(Data.account_path)
	
	if not Data.current_data.has("email"):
		Data.reset_data()
		Data.save_data(Data.account_path)
	else:
		if Data.current_data["remember"] == true:
			LoginPage.get_node("Remember").button_pressed = Data.current_data["remember"]
			LoginPage.get_node("EmailText").text = Data.current_data["email"]
			LoginPage.get_node("PasswordText").text = Data.current_data["password"]


func Login():
	var email = LoginPage.get_node("EmailText").text
	
	var password = LoginPage.get_node("PasswordText").text
	
	if len(password) < 8:
		print("Password!")
		return
	
	SwitchState(true)
	
	Data.current_data["email"] = email
	Data.current_data["password"] = password
	Data.current_data["remember"] = LoginPage.get_node("Remember").button_pressed
	
	Firebase.Auth.login_with_email_and_password(email, password)


func SignUp():
	var email = SignUpPage.get_node("EmailText").text
	
	var password = SignUpPage.get_node("PasswordText").text
	
	var username = SignUpPage.get_node("UsernameText").text
	
	
	if len(password) < 8:
		print("Password!")
		return
	
	if len(username) < 4:
		print("Username!")
	
	Data.current_data["email"] = email
	Data.current_data["password"] = password
	Data.current_data["remember"] = SignUpPage.get_node("Remember").button_pressed
	
	
	SwitchState(true)
	
	Firebase.Auth.signup_with_email_and_password(email, password)


func _on_FirebaseAuth_login_succeeded(auth_info):
	Data.save_data(Data.account_path)
	Core.AuthInfo = auth_info
	get_tree().change_scene_to_file("res://Main/Main.tscn")

func _on_FirebaseAuth_siginUp_succeeded(auth_info):
	Core.AuthInfo = auth_info
	var username = SignUpPage.get_node("UsernameText").text
	
	Core.Change_Username(username, $SignUp/ChangeNameRequest)
	
	
func on_login_failed(code, message):
	printerr(code)
	printerr(message)


func _on_return_login_pressed():
	LoginPage.get_parent().visible = true
	SignUpPage.get_parent().visible = false


func _on_return_sign_up_pressed():
	LoginPage.get_parent().visible = false
	SignUpPage.get_parent().visible = true


func SwitchState(state : bool):
	LoginPage.get_node("EmailText").editable = not state
	LoginPage.get_node("PasswordText").editable = not state
	LoginPage.get_node("ReturnSignUp").disabled = state
	LoginPage.get_node("LoginButton").disabled = state
	
	SignUpPage.get_node("EmailText").editable = not state
	SignUpPage.get_node("PasswordText").editable = not state
	SignUpPage.get_node("UsernameText").editable = not state
	SignUpPage.get_node("ReturnLogin").disabled = state
	SignUpPage.get_node("SignUpButton").disabled = state



func _on_change_name_completed(result, response_code, headers, body):
	Core.AuthInfo["displayname"] = $SignUp/Background/UsernameText.text
	
	Core.WithCreate()
	
	Data.save_data(Data.account_path)
	
	get_tree().change_scene_to_file("res://Main/Main.tscn")
