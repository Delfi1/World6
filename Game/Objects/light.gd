extends DirectionalLight3D

func _process(delta):
	var Camera = get_viewport().get_camera_3d()
	
	#self.rotation.x = - Camera.rotation.x
	#self.rotation.y = Camera.get_parent().rotation.y
	
