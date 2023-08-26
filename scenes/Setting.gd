extends Control

func _ready():
	appendLanguages()
	settingSounds()

	if OS.window_fullscreen:
		$Window/Options/Fullscreen.pressed = true
	else:
		$Window/Options/Windowed.pressed = true

	var config = Global.config

	var dialogNameShows = config.get_value("dialog", "NameShows", "English")
	if dialogNameShows == "English":
		$Dialog/Container/Options/English.pressed = true
	else:
		$Dialog/Container/Options/Translated.pressed = true

	var title = load("res://scenes/components/PageTitle.tscn").instance()
	title.title = "TR:SETTING:TITLE"
	title.buttonIcon = load("res://images/icons/left.png")
	self.add_child(title)


func _on_Setting_hide():
	$Language/List.clear()
	
	
func _on_Title_resized():
	var width = $TitleContainer/Title.rect_size.x
	var fixedWidth = 102 + width + 16
	
	$TitleContainer/BG.rect_size.x = fixedWidth
	$TitleContainer/Right.rect_position.x = fixedWidth + 32


func appendLanguages():
	var locales = TranslationServer.get_loaded_locales()
	for i in locales.size():
		var locale = locales[i]
		var localeName = TranslationServer.get_locale_name(locale)
		
		var icon = load(str("res://locales/", locale, "/assets/icon.png"))
		$Language/List.add_item(localeName, icon)
		$Language/List.set_item_metadata(i, locale)
		
		# 匹配语言
		if locale == TranslationServer.get_locale():
			$Language/List.select(i)

func settingSounds():
	var audioMaster = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$Sound/Container/Master/Volume.value = audioMaster
	
	var audioMusic = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$Sound/Container/Music/Volume.value = audioMusic
	
	var audioVoice = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Voice"))
	$Sound/Container/Voice/Volume.value = audioVoice
	
	var audioEffect = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effect"))
	$Sound/Container/Effect/Volume.value = audioEffect

func _on_List_item_selected(index):
	var locale = $Language/List.get_item_metadata(index)
	
	TranslationServer.set_locale(locale)
	
	Global.saveConfig("system", "language", locale)
	
	pass # Replace with function body.




func _on_Label_size_flags_changed(parent):
	get_node(parent + "/Container/Caption").set("rect_size:x", 330)
	
	pass # Replace with function body.


func _on_Volume_drag_ended(valueChanged, audioBusName):
	#未发生变化则返回
	if !valueChanged:
		return
		
	var node = get_node(str("Sound/Container/", audioBusName, "/Volume"))
	var volume = node.value
	
	Global.saveConfig("audio", audioBusName, volume)
	
	pass # Replace with function body.


func _on_Volume_value_changed(volume, audioBusName):
	var index = AudioServer.get_bus_index(audioBusName)
	AudioServer.set_bus_volume_db(index, volume)
	
	if volume <= -32:
		AudioServer.set_bus_mute(index, true)
	else:
		AudioServer.set_bus_mute(index, false)
	
	pass # Replace with function body.



func _on_Window_pressed(mode):
	if mode == "Fullscreen":
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
		
	Global.saveConfig("system", "Window", mode)
	Global.fixedWindowSizeAndPosition()


func _on_DialogNameShows_pressed(mode):
	Global.saveConfig("dialog", "NameShows", mode)
	pass # Replace with function body.


func _on_DownloadSource_pressed(source):
	Global.saveConfig("download", "Source", source)
	pass # Replace with function body.

