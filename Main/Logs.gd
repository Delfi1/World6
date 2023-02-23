extends Panel


func _ready():
	UpdateText()


func UpdateText():
	$Text.text = "Client version: %s\n" % Core.Version
	
	if Core.Server != null:
		$Text.text += "Server version: %s\n" % Core.Server
	else:
		$Text.text += "Server version: Loading...\n"
	

func _on_timer_timeout():
	UpdateText()
