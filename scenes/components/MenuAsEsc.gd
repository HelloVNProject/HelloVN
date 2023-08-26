extends Node

var clickedElement: String

var white = Color.white
var transparent = Color.transparent
var expo = Tween.TRANS_EXPO
var easeOut = Tween.EASE_OUT


# 进入动效
# parentElement: 父级元素名（Continue）
func tweenMouseEntered(parentElement):
	var interval = 0.5
	var tween = $Tween
	
	var elementTitle = get_node(parentElement + "/Title")
	var elementBGLeft = get_node(parentElement + "/White BG Left")
	var elementBGRight = get_node(parentElement + "/White BG Right")
	var elementBGTransparent = get_node(parentElement + "/Transparent BG")
	
	tween.interpolate_property(elementTitle, "custom_colors/font_color", Color.white, Color.black, interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(elementBGLeft, "rect_size", Vector2(0, 53), Vector2(328, 53), interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(elementBGRight, "rect_size", Vector2(0, 53), Vector2(16, 53), interval, Tween.TRANS_EXPO, Tween.EASE_OUT, interval - interval / 2)
	tween.interpolate_property(elementBGTransparent, "modulate", Color.white, Color.transparent, interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	tween.start()

# 离开动效
# parentElement: 父级元素名（Continue）
func tweenMouseLeaved(parentElement):
	var interval = 0.5
	var tween = $Tween
	
	var elementTitle = get_node(parentElement + "/Title")
	var elementBGLeft = get_node(parentElement + "/White BG Left")
	var elementBGRight = get_node(parentElement + "/White BG Right")
	var elementBGTransparent = get_node(parentElement + "/Transparent BG")
	
	tween.interpolate_property(elementTitle, "custom_colors/font_color", Color.black, Color.white, interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(elementBGLeft, "rect_size", Vector2(328, 53), Vector2(0, 53), interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(elementBGRight, "rect_size", Vector2(16, 53), Vector2(0, 53), interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(elementBGTransparent, "modulate", Color.transparent, Color.white, interval, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	tween.start()


func onSettingClick():
	var sceneName = "SettingScene"
	
	if(!$".".has_node(sceneName)):
		var scene = load("res://scenes/Setting.tscn").instance()
		scene.name = sceneName
		$".".add_child(scene)
		get_node(sceneName + "/PageTitle/Container/Button").connect("pressed", self, "_on_SettingBackButton_pressed")
		
	toggleAllElements("hidden")
	toggleScene(sceneName, "show")
	
func _on_Buttons_mouse_entered(extra_arg_0):
	tweenMouseEntered(extra_arg_0)


func _on_Buttons_mouse_exited(extra_arg_0):
	tweenMouseLeaved(extra_arg_0)


func _on_Buttons_gui_input(event, parentElement):
	var isLeftClick = Input.is_action_pressed("menu_click")
	if(isLeftClick):
		clickedElement = parentElement
		
		if(parentElement == "Back"):
			onBackClick()
		if(parentElement == "History"):
			onHistoryClick()
		if(parentElement == "Option"):
			onSettingClick()
		if(parentElement == "Home"):
			onHomeClick()
		if(parentElement == "Exit"):
			print("Save has been saved: ", Global.slotName)
			Dialogic.save(Global.slotName)
			showQuitDialog()
	
func onBackClick():
	get_parent().isMouseOnMenu = false
	self.visible = false
	
func onHistoryClick():
	# 通过父节点获取到 History 节点
	var parent = get_parent()
	var history = parent.get_node("History")
	
	history._on_toggle_history()
	parent.move_child(history, parent.get_child_count())

	history.get_node("HistoryPopup/PageTitle/Container/Button").connect("pressed", self, "_on_HistoryBackButton_pressed")
	
	toggleAllElements("hidden")
	

func _on_HistoryBackButton_pressed():
	# 通过父节点获取到 History 节点
	var parent = get_parent()
	var history = parent.get_node("History")
	
	history._on_toggle_history(false)
#	history.get_node("HistoryPopup").visible = false
	
	toggleAllElements("show")
	
func onHomeClick():
	print("Save has been saved: ", Global.slotName)
	Dialogic.save(Global.slotName)
	
	var root = Global.rootTree
	root.change_scene("res://scenes/Main.tscn")

func toggleAllElements(toggle, interval = 2):
	var elements = ["Title", "Home", "History", "Back", "Option", "Exit"]
	
	for i in elements.size():
		if toggle == "show":
			$Tween.interpolate_property(get_node(elements[i]), "modulate", transparent, white, interval, expo, easeOut)
		else:
			$Tween.interpolate_property(get_node(elements[i]), "modulate", white, transparent, interval, expo, easeOut)
	
	$Tween.start()

	
func toggleScene(scene, toggle, interval = 2):
	if toggle == "show":
		get_node(scene).visible = true
		$Tween.interpolate_property($BlurBG, "modulate", transparent, white, interval, expo, easeOut)
	if toggle == "hidden":
		get_node(scene).visible = false
		$Tween.interpolate_property($BG, "visible", true, false, interval, expo, easeOut, interval / 2)
	
	$Tween.start()
	
func _on_SettingBackButton_pressed():
	toggleAllElements("show")
	toggleScene("SettingScene", "hidden")


func showQuitDialog():
	Global.IsMenuSubMenu = true
	
	var quitDialog = preload("res://scenes/components/QuitDialog.tscn").instance()
	call_deferred("add_child", quitDialog)
