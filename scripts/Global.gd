extends Node

var config: ConfigFile
var rootTree: SceneTree
var rootCamera2D: Camera2D

var IsFilmMode: bool # 电影模式
var IsFocusMode: bool #聚焦电影模式
var IsMenuSubMenu: bool = false # 在首页的子菜单里

var slotName: String = "UserSlot01"
var configPath = "user://settings.properties"

# 角色名列表
const arrayDialogChars = ["Gr", "Seaon", "Can", "Romin", "Sam", "Nik", "Yao", "Todd", "Amorog", "Ten"]

# 初始化游戏
func init():
	config = loadConfigs()
	
	# 初始化语言文件
	var languages = Languages.new()
	languages.init()
	
	# 调整用户语言
	var language = config.get_value("system", "language", OS.get_locale_language())
	if language != null:
		TranslationServer.set_locale(language)
	
	var audioKeys = config.get_section_keys("audio")
	for audioKey in audioKeys:
		var busIndex = AudioServer.get_bus_index(audioKey)
		var audioVolume = config.get_value("audio", audioKey, 0)

		AudioServer.set_bus_volume_db(busIndex, audioVolume)

		if audioVolume <= -32:
			AudioServer.set_bus_mute(busIndex, true)
		else:
			AudioServer.set_bus_mute(busIndex, false)
#
	var window = config.get_value("system", "Window", "Fullscreen")
	if window != "Fullscreen":
		OS.set_window_fullscreen(false)
		fixedWindowSizeAndPosition()
		

# 解析文字
# texts: 待解析的字符串
# dict: 解析字典，无需大括号，{"artist": "艺术家"}
func parseTexts(texts, dict = {}):
	for i in dict.keys().size():
		var key = dict.keys()[i]
		var value = String(dict[key])
		
		texts = texts.replace("{" + key + "}", value)
	
	return texts

# 获取指定字符串中间的字符串
# text：字符串
# begin：指定前面字符串
# end：指定后面字符串
func getBetweenString(text, begin, end):
	var compile = str("(", begin, "=?)(\\S*)(?=", end, ")")
#	var compile = str("(", begin, "=?)(.+?)(?=", end, ")")
	
	var regex = RegEx.new()
	regex.compile(compile)
	var result = regex.search(text)
	
	if result:
		return result.get_string()
		
	return text
	
func searchAllRegex(text, begin, end):
	var compile = str("(", begin, "=?)(.+?)(?=", end, ")")
	
	var regex = RegEx.new()
	regex.compile(compile)
	var result = regex.search_all(text)
	
	return result

# 获取所有语言下指定 Key 的 Value
# key：键
# result [{locale, text}, ...]
func getValuesFromAllTranslations(key, defaultValue = ""):
	var originLocale = TranslationServer.get_locale()
	var allLocales = TranslationServer.get_loaded_locales()
	print(allLocales)
	
	var result = []
	
	# 加载所有语言中的指定 Key 的 value
	for locale in allLocales:
		TranslationServer.set_locale(locale)
		var tred = tr(key)
		
		# 如果 key value 相同则表示未翻译，取 defaultValue
		if key == tred:
			tred = defaultValue
		
		var temp = {
			"locale": locale,
			"text": tred
		}
		
		result.append(temp)
		
	TranslationServer.set_locale(originLocale) #设回默认语言
	return result

# 加载所有设定
func loadConfigs():
	var config = ConfigFile.new()
	config.load(configPath)
	
	return config

func configFileToDictionary(config: ConfigFile) -> Dictionary:
	var resultDict = {}

	# 获取配置文件中的所有节
	var sections = config.get_sections()

	for section in sections:
		var sectionDict = {}

		# 获取节中所有键
		var keys = config.get_section_keys(section)

		for key in keys:
			# 获取键对应的值
			var value = config.get_value(section, key)

			# 将键值对添加到节字典中
			sectionDict[key] = value

		# 将节字典添加到结果字典中
		resultDict[section] = sectionDict

	return resultDict


# 获取一个配置的数据
func getConfig(section, key, default = null):
	var config = loadConfigs()
	return config.get_value(section, key, default)

# 保存指定设定
func saveConfig(section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(configPath)

# 解析对话
# text：内容
func dialogParsing(text):
	var dialogNameShows = config.get_value("dialog", "NameShows", "English")
	
#	text = text.replace("\n", "[br]")
	
	for charId in arrayDialogChars:
		var trCharKey = str("Tr", charId)
		
		# 如果目标角色不存在于该对话则跳过
		if str(text).countn(trCharKey) == 0:
			continue
		
		# 否则获取该角色的名称翻译结果
		var charTrKey = str("TR:", charId, ":NICKNAME")
		
		# 获取对话显示形式，英文则添加 :ENG
		if dialogNameShows == "English":
			charTrKey += ":ENG"
		
		# 变成全大写
		charTrKey = charTrKey.to_upper()
		
		 # 替换到对话
		text = text.replace(trCharKey, tr(charTrKey))
		
	return text

# 解析角色名
# name：角色名
func dialogNameParsing(name):
	var dialogNameShows = config.get_value("dialog", "NameShows", "English")
		
	# 否则获取该角色的名称翻译结果
	var charTrKey = str("TR:", name, ":NICKNAME")
		
	# 获取对话显示形式，英文则添加 :ENG
	if dialogNameShows == "English":
		charTrKey += ":ENG"
		
	# 变成全大写
	charTrKey = charTrKey.to_upper()
		
	return tr(charTrKey)

# 修正窗口尺寸和位置
# ratio：缩放比例
func fixedWindowSizeAndPosition(ratio = 0.8):
	var screenSize = OS.get_screen_size()
		
	# 根据屏幕尺寸修正窗口尺寸
	var fixedWidth = screenSize.x * ratio
	var fixedHeight = fixedWidth / 1.7777778
	var fixedTop = (screenSize.y - fixedHeight) / 2
	var fixedLeft = (screenSize.x - fixedWidth) / 2
		
	OS.set_window_size(Vector2(fixedWidth, fixedHeight))
	OS.set_window_position(Vector2(fixedLeft, fixedTop))

## 获取用户完成的章节编号
## return Float: 1.00, 2.03
func getUserLatestChapter():
	var config = loadConfigs()
	return float(config.get_value("Saved", "LatestChapter", "1.00"))

# 格式化文件尺寸到人类易读格式
func formatFileSize(fileSize: int) -> String:
	var size = fileSize
	var units = ["B", "KB", "MB", "GB", "TB"]
	var unitIndex = 0

	while size >= 1024 and unitIndex < units.size() - 1:
		size /= 1024
		unitIndex += 1

	return str(size) + " " + units[unitIndex]

func tweenBuilder(tween: Tween, object: Object, property: NodePath, endValue, duration: float, 
				delay: float = 0, startValue = null):
	if startValue == null:
		startValue = object.get(property)
	
	tween.interpolate_property(object, property, startValue, endValue, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, delay)
	
	return tween

func createAToast(node: Node, title: String, duration: int = 3):
	var topBar = preload("res://scenes/components/TopBar.tscn").instance()
	topBar.title = title
	topBar.duration = duration
	node.add_child(topBar)

# 格式化【秒】到人类易读时间：512 -> 8 分 32 秒
func formatTime(seconds: int) -> String:
	var days = seconds / 86400
	seconds -= days * 86400

	var hours = seconds / 3600
	seconds -= hours * 3600

	var minutes = seconds / 60
	var remainingSeconds = seconds % 60

	var timeString = ""

	if days > 0:
		timeString += str(days, " ", tr("TR:SYSTEM:TIME:DAY"), " ")
	if hours > 0:
		timeString += str(hours, " ", tr("TR:SYSTEM:TIME:HOUR"), " ")
	if minutes > 0:
		timeString += str(minutes, " ", tr("TR:SYSTEM:TIME:MINUTE"), " ")
	if remainingSeconds > 0 and days == 0:
		timeString += str(remainingSeconds, " ", tr("TR:SYSTEM:TIME:SECOND"))

	return timeString

func sleep(second):
	yield(get_tree().create_timer(second), "timeout")

func isAndroid():
	return OS.has_feature("Android")
