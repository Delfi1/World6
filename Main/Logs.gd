extends Panel


func _ready():
	UpdateText()


func UpdateText():
	$Text.text = "Client version: %s\n" % Core.Version
	
	if Core.Server != null:
		$Text.text += "Server version: %s\n" % Core.Server
	else:
		$Text.text += "Server version: Loading...\n"
	
	await get_tree().create_timer(1).timeout
	UpdateText()
	return
