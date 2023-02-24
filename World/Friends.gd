extends Node


var List = {
	
}

var default_friend = {
	"Name" : "",
	"State" : 0
}

func GetFriendsList(success : Callable, error : Callable):
	Core.GetDocument('Users', Core.UserData["UUID"], success, error)


func GetFriendInfo(id : String, success : Callable, error : Callable):
	Core.GetDocument('Users', id, success, error)


func AddFriend(id):
	pass
	# Изменить свой и чужой doc, поставить 2 и 3 state

