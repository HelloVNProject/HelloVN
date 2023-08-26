extends Control

var clickedElement: String

var white = Color.white
var transparent = Color.transparent
var expo = Tween.TRANS_EXPO
var easeOut = Tween.EASE_OUT

func _ready():
	# 没有历史存档则不显示继续游戏按钮
	if !Dialogic.get_slot_names().has(Global.slotName):
		remove_child($Continue)
		moveButtonsPos(0, -64)
		
	var localVersion = Updater.getGameVersion()
	var versionMode = "production" if Api.isProduction() else "debug"
	var bottomInfo = str("HelloVN", " Version ", localVersion, " (", versionMode, ")")
	$"Bottom Info".text = bottomInfo
	
	# 这段不要删，因为需要时间处理语言服务器
	yield(Global.sleep(3), "completed")
	var belongsToast = preload("res://scenes/components/BelongsToast.tscn").instance()
	belongsToast.id = "bgm1"
	add_child(belongsToast)
	

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


# 继续故事
func continueStory():
	var interval = 2
	
	var elementBGM = get_node("BGM")
	elementBGM.playing = false
	
	Dialogic.load(Global.slotName)
	var dialog = Dialogic.start()
	$Dialogic.add_child(dialog)
	

# 开始新故事
func newStory():
	var interval = 2
	var tween = get_node("Tween Click")
	Global.IsMenuSubMenu = true

	var elementBGM = get_node("BGM")
	tween.interpolate_property(elementBGM, "volume_db", 0, -50, interval * 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	Global.tweenBuilder(tween, elementBGM, "playing", false, 1, interval * 3)

	var camera = Global.rootCamera2D
	Global.tweenBuilder(tween, camera, "offset", Vector2(0, 0), interval)

	toggleAllElements("hidden")

	tween.start()

	yield(Global.sleep(interval), "completed")
	
	var dialog = Dialogic.start("Start")
	$Dialogic.add_child(dialog)
	
func extra():
	var sceneName = "ExtraScene"
	
	if(!$".".has_node(sceneName)):
		var scene = load("res://scenes/Extra.tscn").instance()
		scene.name = sceneName
		$".".add_child(scene)
		get_node(sceneName + "/PageTitle/Container/Button").connect("pressed", self, "_on_ExtraBackButton_pressed")
		
	$Tween.remove_all()
	
	toggleAllElements("hidden")
	bgScale(Vector2(2, 2), Vector2(-800, -100))
	toggleScene("ExtraScene", "show")

func setting():
	var sceneName = "SettingScene"
	
	if(!$".".has_node(sceneName)):
		var sceneRaw = load("res://scenes/Setting.tscn")
		var scene = sceneRaw.instance()
		
		scene.name = sceneName
		$".".add_child(scene)
		get_node(sceneName + "/PageTitle/Container/Button").connect("pressed", self, "_on_SettingBackButton_pressed")
	
	$Tween.remove_all()
	
	toggleAllElements("hidden")
	bgScale(Vector2(1.5, 1.5), Vector2(-600, -300))
	toggleScene(sceneName, "show")

func archive():
	Global.IsMenuSubMenu = true
	
	var sceneName = "ArchiveScene"
	
	if(!$".".has_node(sceneName)):
		var scene = load("res://scenes/archive/Archive.tscn").instance()
		scene.name = sceneName
		$".".add_child(scene)
		get_node(sceneName + "/PageTitle/Container/Button").connect("pressed", self, "_on_ArchiveBackButton_pressed")
	
	$Tween.remove_all()
	
func _on_Buttons_mouse_entered(extra_arg_0):
	tweenMouseEntered(extra_arg_0)


func _on_Buttons_mouse_exited(extra_arg_0):
	tweenMouseLeaved(extra_arg_0)


func _on_Buttons_gui_input(event, parentElement):
	var isLeftClick = Input.is_action_pressed("menu_click")
	if(isLeftClick):
		clickedElement = parentElement
		
		if(parentElement == "Continue"):
			continueStory()
		if(parentElement == "New"):
			newStory()
		if(parentElement == "Option"):
			setting()
		if(parentElement == "Archive"):
			archive()
		if(parentElement == "Chatper"):
			pass
		if(parentElement == "Extra"):
			extra()
		if(parentElement == "Exit"):
			showQuitDialog()
	

func toggleAllElements(toggle, interval = 2):
	var elements = ["Title", "Bottom Info", "New", "Archive", "Chapter", "Option", "Extra", "Exit"]
	
	if has_node("Continue"):
		elements.append("Continue")
	
	for i in elements.size():
		if toggle == "show":
			$Tween.interpolate_property(get_node(elements[i]), "modulate", transparent, white, interval, expo, easeOut)
		else:
			$Tween.interpolate_property(get_node(elements[i]), "modulate", white, transparent, interval, expo, easeOut)
	
	$Tween.start()
	
func bgScale(scale, position, interval = 2):
	var oldScale = $BG.rect_scale
	var oldPosition = $BG.rect_position
	
	$Tween.interpolate_property($BG, "rect_scale", oldScale, scale, interval, expo, easeOut)
	$Tween.interpolate_property($BG, "rect_position", oldPosition, position, interval, expo, easeOut)
	
	$Tween.start()
	
func toggleScene(scene, toggle, interval = 2):
	if toggle == "show":
		Global.IsMenuSubMenu = true
		$BG.visible = true
		$BlurBG.visible = true
		get_node(scene).visible = true
		$Tween.interpolate_property($BlurBG, "modulate", transparent, white, interval, expo, easeOut)
	if toggle == "hidden":
		Global.IsMenuSubMenu = false
		get_node(scene).visible = false
		$Tween.interpolate_property($BlurBG, "modulate", white, transparent, interval, expo, easeOut)
		$Tween.interpolate_property($BlurBG, "visible", true, false, interval, expo, easeOut, interval / 2)
		$Tween.interpolate_property($BG, "visible", true, false, interval, expo, easeOut, interval / 2)
	
	$Tween.start()
	
func _on_ExtraBackButton_pressed():
	toggleAllElements("show")
	bgScale(Vector2(1, 1), Vector2(0, 0))
	toggleScene("ExtraScene", "hidden")
	$".".remove_child(get_node("ExtraScene"))
	
func _on_SettingBackButton_pressed():
	toggleAllElements("show")
	bgScale(Vector2(1, 1), Vector2(0, 0))
	toggleScene("SettingScene", "hidden")
	$".".remove_child(get_node("SettingScene"))
	
func _on_ArchiveBackButton_pressed():
	toggleScene("ArchiveScene", "hidden")
	$".".remove_child(get_node("ArchiveScene"))

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var isPlaying = false
		# 游戏退出前，进入时间线后则保存
		if Dialogic.has_current_dialog_node():
			isPlaying = true
			print("Save has been saved: ", Global.slotName)
			Dialogic.save(Global.slotName)
			
		showQuitDialog(isPlaying)
		return
		

# 相对移动按钮元素的位置
func moveButtonsPos(x = 0, y = 0):
	var elements = ["New", "Chapter", "Archive", "Option", "Extra", "Exit"]
	
	if has_node("Continue"):
		elements.append("Continue")
		
	for i in elements.size():
		if !has_node(elements[i]):
			continue
		
		var element = get_node(elements[i])
		var rectPosition = element.rect_position
		
		element.rect_position = Vector2(rectPosition.x + x, rectPosition.y + y)


func showQuitDialog(isPlaying = false):
	Global.IsMenuSubMenu = true
	
	var quitDialog = preload("res://scenes/components/QuitDialog.tscn").instance()
	if isPlaying:
		$Dialogic/dialogic/DialogNode.add_child(quitDialog)
	else:
		call_deferred("add_child", quitDialog)
