extends Control

@onready
var ExitButton = $Exit

@onready
var UpdateTimer = $System/Timer

func _ready():
	$Info.text = Information()
	UpdateTimer.start(10)

func _input(event):
	if event.is_action_pressed("escape"):
		_on_exit_pressed()
	
	ExitButton.visible = Core.OnFullscreen()

func Information():
	var stats = "Client Version: %s" % Core.Version
	
	if Core.ServerVer != null:
		stats = AddLine(stats, "Server Version: %s" % Core.ServerVer)
	
	print(Core.AuthInfo)
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
	
	UpdateTimer.start(60)
