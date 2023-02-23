extends Panel

@onready var ListButton = $ListButton

@onready var AddFriendButton = $AddFriendButton

@onready var Pages = {
	0 : $PageList,
	1 : $PageAddFriend
}


func ChangePage(page):
	for i in range(len(Pages)):
		Pages[i].visible = false
	page.visible = true



func _on_list_button_pressed():
	AddFriendButton.button_pressed = false
	ListButton.button_pressed = true
	ChangePage($PageList)


func _on_add_friend_button_pressed():
	ListButton.button_pressed = false
	AddFriendButton.button_pressed = true
	ChangePage($PageAddFriend)
	
