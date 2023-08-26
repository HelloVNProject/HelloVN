extends Control


func init():
	$Part1.visible = true
	$Part2.visible = false
	
	$Part1/Margin/Grid/Email.modulate = Color.transparent
	$Part1/Margin/Grid/Subcribe.visible = false
	$Part1/Margin/Grid/TwoFA.visible = false
	$Part1/Margin/Grid/DataSync.visible = false
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var title = preload("res://scenes/components/PageTitle.tscn").instance()
	title.title = tr("TR:REGISTER:TITLE")
	$Part1.add_child(title)
	
	var tween = $Tween
	Global.tweenBuilder(tween, $Part1/Margin/Grid/Email, "modulate", Color.white, 1)
	tween.start()
	
	yield(get_tree().create_timer(0.5), "timeout")
	var temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.name = "Skip"
	temp.title = tr("TR:REGISTER:BUTTON:TOARCHIVE")
	temp.icon = load("res://images/icons/skip-end-fill.png")
	temp.connect("onClick", self, "_on_left_button_click")
	$Part1.add_child(temp)
	
	yield(get_tree().create_timer(0.5), "timeout")
	temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.name = "Register"
	temp.type = "Right"
	temp.title = tr("TR:REGISTER:BUTTON:SUBMIT")
	temp.icon = load("res://images/icons/done.png")
	temp.connect("onClick", self, "_on_right_button_click")
	$Part1.add_child(temp)

func _on_right_button_click():
	var email = $Part1/Margin/Grid/Email/Input.text
	if email.length() <= 0:
		return Global.createAToast(self, tr("TR:REGISTER:TIP:EMAIL"))
	
	register()
	
func register():
	switchLoading(true)
	
	Global.createAToast(self, tr("TR:REGISTER:TIP:CONNECTING"))
	
	var email = $Part1/Margin/Grid/Email/Input.text
	var subscribe = $Part1/Margin/Grid/Subcribe/Check1.pressed
	var twoFa = $Part1/Margin/Grid/TwoFA/Check1.pressed
	var dataSync = $Part1/Margin/Grid/DataSync/Check1.pressed
	var saveData = null
	var settingData = null
	
	if dataSync == null or twoFa == false:
		dataSync = false
	
	if dataSync:
		saveData = Dialogic.export()
		settingData = Global.configFileToDictionary(Global.loadConfigs())
	
	var registerData = {
		"deviceId": Api.innieGetDeviceId(),
		"email": email,
		"subscribe": subscribe,
		"twoFa": twoFa,
		"dataSync": dataSync,
		"saveData": saveData,
		"settingData": settingData
	}
	var response = yield(Api.register(registerData), "completed")
	
	# 获取失败时返回
	if response["code"] != 200:
		switchLoading(false)
		var errorMsg = tr(str("TR:API:MSG:", response["code"]))
		return Global.createAToast(self, Global.parseTexts(tr("TR:REGISTER:TIP:FAILED"), {
			"msg": errorMsg
		}))
		
	var responseData = response["data"]
	registered(registerData, responseData)

# 登记完毕后的响应
# data：response[data]
func registered(registerData, responseData):
	$Part1.visible = false
	$Part2.visible = true
	$Part2/BGTemp.visible = false
	$Part2/Margin/HBox/Right/QrCodeContainer.visible = false
	$Part2/Margin/HBox/Right/Tip.visible = false
	
	var title = preload("res://scenes/components/PageTitle.tscn").instance()
	title.title = tr("TR:REGISTERED:TITLE")
	$Part2.add_child(title)
	
	var email = registerData["email"]
	var enableSubscribe = registerData["subscribe"]
	var enableTwoFa = registerData["twoFa"]
	var enableSaveData = registerData["dataSync"]
	
	var dataSaved = responseData["dataSaved"]
	var deviceKey = responseData["deviceKey"]
	var twoFaQrcodeData = responseData["twoFaQrcodeData"]
	var twoFaCodes = responseData["twoFaCodes"]
	
	$Part2/Margin/HBox/Left/Email/Content.text = Global.parseTexts(tr("TR:REGISTERED:EMAIL:CONTENT"), {
		"email": email
	})
	$Part2/Margin/HBox/Left/Subscribe/Content.text = tr(str("TR:REGISTERED:SUBSCRIBE:", enableSubscribe).to_upper())
	$Part2/Margin/HBox/Left/DataSync/Content.text = tr(str("TR:REGISTERED:DATASYNC:", enableSaveData).to_upper())
	$Part2/Margin/HBox/Right/Caption.text = tr(str("TR:REGISTERED:TWOFA:", enableTwoFa).to_upper())
	if enableTwoFa:
		$Part2/Margin/HBox/Right/QrCodeContainer.visible = true
		$Part2/Margin/HBox/Right/Tip.visible = true
		buildTwoFaQrCode(twoFaQrcodeData, email, twoFaCodes)
	
	Global.saveConfig("User", "DeviceKey", deviceKey)
	
	yield(get_tree().create_timer(1), "timeout")
	var temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.name = "Archive"
	temp.title = tr("TR:REGISTERED:BUTTON:TOARCHIVE")
	temp.icon = load("res://images/icons/skip-end-fill.png")
	temp.connect("onClick", self, "_on_left_button_click")
	$Part2.add_child(temp)
	
func buildTwoFaQrCode(twoFaQrcodeData, email, twoFaCodes):
	var qr_code: QrCode = QrCode.new()
	qr_code.error_correct_level = QrCode.ERROR_CORRECT_LEVEL.LOW
	var texture: ImageTexture = qr_code.get_texture(twoFaQrcodeData)
	$Part2/Margin/HBox/Right/QrCodeContainer/Image.texture = texture
	$Part2/Margin/HBox/Right/QrCodeContainer/InfoContainer/Name/Content.text = str("Hello VN (", email, ")")
	$Part2/Margin/HBox/Right/QrCodeContainer/InfoContainer/Key/Content.text = twoFaCodes

func _on_left_button_click():
	var archive = preload("res://scenes/archive/Archive.tscn").instance()
	archive.rect_position.x = -1920
	archive.useTitleButton = false
	self.add_child(archive)
	
	var tween = $Tween
	Global.tweenBuilder(tween, $Part1, "rect_position:x", 1920, 2)
	
	if self.has_node("Part2"):
		Global.tweenBuilder(tween, $Part2, "rect_position:x", 1920, 2)
		
	Global.tweenBuilder(tween, archive, "rect_position:x", 0, 2)
	tween.start()
	
	var temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.name = "Next"
	temp.title = tr("TR:REGISTER:BUTTON:TOHOME")
	temp.icon = load("res://images/icons/home.png")
	temp.connect("onClick", self, "_on_archive_left_button_click")
	self.add_child(temp)

func switchLoading(isLoading):
	var transparent = 0.3
	
	if !isLoading:
		transparent = 1
	
	var tween = $Tween
	Global.tweenBuilder(tween, $Part1/Margin/Grid, "modulate", Color(1, 1, 1, transparent), 1)
	Global.tweenBuilder(tween, $Part1/Register, "moulate", Color(1, 1, 1, transparent), 1)
	Global.tweenBuilder(tween, $Part1/Skip, "moulate", Color(1, 1, 1, transparent), 1)
	tween.start()
	

func _on_2fa_toggled(button_pressed):
	if button_pressed:
		$Part1/Margin/Grid/DataSync.visible = true
		return
	
	$Part1/Margin/Grid/DataSync.visible = false
	


func _on_Email_text_changed(new_text):
	if new_text.length() > 0:
		$Part1/Margin/Grid/Subcribe.visible = true
		$Part1/Margin/Grid/TwoFA.visible = true
		return
		
	$Part1/Margin/Grid/Subcribe.visible = false
	$Part1/Margin/Grid/TwoFA.visible = false

func _on_archive_left_button_click():
	get_tree().change_scene("res://scenes/Main.tscn")
