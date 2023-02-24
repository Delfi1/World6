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
	


func _on_send_button_pressed():
	var friend_id = $PageAddFriend/Panel/FriendIdText.text
	
	
	if len(friend_id) != 28:
		PrintInfo("Invalid User ID")
		return
	
	ClearInfo()
	
	if Friends.List.has(friend_id):
		print(Friends.List[friend_id])
		
		var state = int(Friends.List[friend_id]["State"])
		
		match state:
			1:
				PrintInfo("You already friends!")
			2:
				PrintInfo("You already send friend request!")
			3:
				pass
		
		return
	
	Friends.AddFriend(friend_id)
	
	

func PrintInfo(Info : String):
	$PageAddFriend/Panel/Information.text = Info

func ClearInfo():
	$PageAddFriend/Panel/Information.text = ""
