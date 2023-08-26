extends Control

export var type : String = "Left"
export var icon : Resource = null
export var title : String = ""
export var isDarkMode: bool = false # 是否为夜间模式，夜间模式：白底黑字；日间模式：黑底白字

signal onClick

func _ready():
	initButton(type)

func initButton(type):
	switchStyle(self.isDarkMode)
	
	if type == "Left":
		$Right.visible = false
		
		$Left/Title.text = title
		$Left/Icon.texture = icon
		$Left.rect_position.x = 0 - $Left.rect_size.x
		
		var tween = $Left/Tween
		Global.tweenBuilder(tween, $Left, "rect_position:x", 0, 1)
		tween.start()
	
	if type == "Right":
		$Left.visible = false
		
		$Right/Title.text = title
		$Right/Icon.texture = icon
		$Right.rect_position.x = 1920 + $Right.rect_size.x
		
		var tween = $Right/Tween
		Global.tweenBuilder(tween, $Right, "rect_position:x", 1920, 1)
		tween.start()

func switchStyle(isDarkMode):
	if isDarkMode:
		get_node(type + "/BGLeft").color = Color.white
		get_node(type + "/BGRight").color = Color.white
		get_node(type + "/Icon").modulate = Color.black
		get_node(type + "/Title").modulate = Color.black
	else:
		get_node(type + "/BGLeft").color = Color.black
		get_node(type + "/BGRight").color = Color.black
		get_node(type + "/Icon").modulate = Color.white
		get_node(type + "/Title").modulate = Color.white

func _on_gui_input(event, argType):
	# 点击事件
	if Input.is_action_pressed("menu_click"):
		emit_signal("onClick")


func _on_mouse_entered(argType):
	var tween = get_node(argType + "/Tween")
	tween.stop_all()
	
	var colors = [Color.white, Color.black]
	
	if isDarkMode:
		colors = [Color.black, Color.white]
	
	Global.tweenBuilder(tween, get_node(argType + "/BGLeft"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node(argType + "/BGRight"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node(argType + "/Icon"), "modulate", colors[1], 1)
	Global.tweenBuilder(tween, get_node(argType + "/Title"), "modulate", colors[1], 1)
	
	tween.start()


func _on_mouse_exited(argType):
	var tween = get_node(argType + "/Tween")
	tween.stop_all()
	
	var colors = [Color.black, Color.white]
	
	if isDarkMode:
		colors = [Color.white, Color.black]
		
	Global.tweenBuilder(tween, get_node(argType + "/BGLeft"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node(argType + "/BGRight"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node(argType + "/Icon"), "modulate", colors[1], 1)
	Global.tweenBuilder(tween, get_node(argType + "/Title"), "modulate", colors[1], 1)
	
	tween.start()


func _on_Title_resized(argType):
	if argType == "Left":
		var mixedSizeX = $Left/Title.rect_position.x + $Left/Title.rect_size.x
		
		$Left/BGLeft.rect_size.x = mixedSizeX + 20
		$Left/BGRight.rect_position.x = mixedSizeX + 40
		$Left.rect_size.x = $Left/BGRight.rect_position.x + 20
		
	if argType == "Right":
		var mixedSizeX = 120 + $Right/Title.rect_size.x
		
		$Right/Title.rect_position.x = mixedSizeX
		$Right/BGLeft.rect_size.x = mixedSizeX + 20
		$Right/BGRight.rect_position.x = mixedSizeX + 40
		$Right.rect_size.x = $Right/BGRight.rect_position.x + 20

