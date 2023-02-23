extends Node


var List = {
	
}


func GetFriendsList(success : Callable, error : Callable):
	Core.GetDocument('Users', Core.UserData["UUID"], success, error)


func GetFriendInfo(id : String, success : Callable, error : Callable):
	Core.GetDocument('Users', id, success, error)


func AddFriend(id):
	pass


