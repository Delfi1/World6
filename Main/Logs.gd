extends Panel

func _ready():
	$Text.text = "Client version: %s\n" % Core.Version
