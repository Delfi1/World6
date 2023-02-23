extends Node


var List = {
	
}


func GetFriendsList(success : Callable, error : Callable):
	Core.GetDocument('Users', Core.UserData["UUID"], success, error)


func DisconnectFriends(collection_id, function : Callable, error : Callable):
	var collection = Firebase.Firestore.collection('Users/%s/Friends' % Core.UserData["Name"])
	collection.disconnect("get_document", function)
	collection.disconnect("error", error)


func GetFriendInfo(id : String, success : Callable, error : Callable):
	Core.GetDocument('Users', id, success, error)


func AddFriend(id):
	pass


