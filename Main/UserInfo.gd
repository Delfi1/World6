extends Panel


func _ready():
	$Tile.text = Core.UserData["Name"]
	UpdateText()


func UpdateText():
	$Text.text = "Email: %s\n" % Core.UserData["Email"]
	$Text.text += "User ID: %s\n" % Core.UserData["UUID"]


func _on_timer_timeout():
	UpdateText()

