extends Node

var Version = "0.0.0.3"

var ServerVer = null

var AuthInfo = null

var PckUrl = ""

var VerUrl = ""

func _input(event):
	if event.is_action_pressed("F11"):
		if get_viewport().get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_viewport().get_window().mode = Window.MODE_MAXIMIZED
			return
		
		get_viewport().get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	


func VerMatch():
	var ver = int(Version[0]) * 1000 + int(Version[2]) * 100 + int(Version[4]) * 10 + int(Version[6])
	
	var Sver = int(ServerVer[0]) * 1000 + int(ServerVer[2]) * 100 + int(ServerVer[4]) * 10 + int(ServerVer[6])
	print("V%s, Sv%s" % [ver, Sver])
	return (Sver <= ver)

func Update(Request : HTTPRequest):
	if not VerMatch():
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
	
