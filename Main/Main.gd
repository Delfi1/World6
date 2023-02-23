extends Control


func _ready():
	Core.WindowMinSize(Vector2i(1280, 720))
	CheckUpdate()
	
	$System/Timer.start(10)

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
