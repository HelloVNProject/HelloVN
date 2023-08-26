extends Control

func _ready():
	Global.rootTree = get_tree()
	
	Global.init()
	
	get_tree().set_auto_accept_quit(false)

	Global.rootCamera2D = $Camera

	$UpdateScene.visible = true
	
	Global.IsMenuSubMenu = true
	
	# 如果 Splash 已不再显示则不显示
	if Global.getConfig("System", "SplashHidden", false):
		Global.IsMenuSubMenu = false
		$Splash.visible = false
	else:
		$Splash.visible = true
		
	
	
#	get_tree().change_scene("res://scenes/chapter-end/ChapterEnd.tscn")
	
#	print(Api.innieGetDeviceId())
#	print(yield(Api.batchInsertUserQTEs([
#		{
#			"nodeId": 17,
#			"choice": 1,
#			"details": {}
#		}
#	]), "completed"))
	
#	get_tree().change_scene("res://scenes/archive/Archive.tscn")

func _input(event):
	if event is InputEventMouseMotion:
		# 如果在首页的子菜单里则不移动摄像机，同时位置归零
		if Global.IsMenuSubMenu:
			movePositions(0, true)
			return
		
		var mousePosition = event.position
		var x = mousePosition.x / 3

		movePositions(x)


func movePositions(x, withEase = false):
	if withEase:
		var tween = $Tween
		Global.tweenBuilder(tween, $Camera, "offset:x", x, 1)
		Global.tweenBuilder(tween, $Menu, "rect_position:x", x, 1)
		Global.tweenBuilder(tween, $UpdateScene, "rect_position:x", x, 1)
		tween.start()
	else:
		$Camera.offset.x = x
		$Menu.rect_position.x = x
		$UpdateScene.rect_position.x = x
