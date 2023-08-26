tool
extends Control

const dictEventsId = {
	"文字": "dialogic_001",
	"角色": "dialogic_002",
	"标签": "dialogic_015",
	"变量": "dialogic_014",
	"时间线": "dialogic_020",
	"背景": "dialogic_021",
	"等待": "dialogic_023",
	"主题": "dialogic_024",
	"音效": "dialogic_030",
	"音乐": "dialogic_031",
	"信号": "dialogic_040",
	
	"注释": "dialogic_999",
	"注释 ——": "dialogic_999",
}

var characters = {}
var themes = {}

var dialogTextIndex = 1 #动态对话编号，用来翻译文本，完成构建后需要置 1
var dialogInit = {} #动态对话初始化数据（JSON 解析），完成构建后需要清空
var dialogCsv = [] #动态翻译 CSV 资源的一个二维数组，用来帮助翻译，完成构建后需要清空

func _ready():
	$Container/CsvContainer/FileDialog.set_filters(PoolStringArray(["*.csv ; CSV Files"]))
	$Container/OutputContainer/FileDialogOutput.set_filters(PoolStringArray(["*.json ; Dialogic Timeline File"]))
	
	pass


func _on_ButtonLoad_button_up():
	$Container/CsvContainer/FileDialog.popup_centered_ratio()
	pass # Replace with function body.



func _on_FileDialog_file_selected(path):
	$Container/CsvContainer/Edit.text = path
	
	pass # Replace with function body.


func _on_ButtonSave_pressed():
	$Container/OutputContainer/FileDialogOutput.current_dir = $Container/OutputContainer/Edit.text
	$Container/OutputContainer/FileDialogOutput.popup_centered_ratio()
	
	pass # Replace with function body.

func builder():
	dialogTextIndex = 1
	dialogInit = {}
	dialogCsv = []
	
	var result = {
		"events": [],
		"metadata": {}
	}
	
	var csvFilePath = $Container/CsvContainer/Edit.text
	
	var file = File.new()
	file.open(csvFilePath, file.READ)
	
	var i = 0
	
	while !file.eof_reached():
		var oneLine = file.get_csv_line()
		var event = parsingLine(oneLine, i)
		
		if event:
			result.events.append(event)
			
		i += 1
	
	file.close()
	
	var outputFilePath = $Container/OutputContainer/Edit.text
	var outputSplits = outputFilePath.split("/")
	var fileName = outputSplits[outputSplits.size() - 1]
	
	result.metadata = {
		"dialogic-version": "1.4.5",
		"file": fileName,
		"name": dialogInit["TimelineName"]
	}
	
	var resultJsoned = JSON.print(result)
	
	var outputFile = File.new()
	outputFile.open(outputFilePath, File.WRITE)
	outputFile.store_string(resultJsoned)
	outputFile.close()
	
	# 如果要求导出 CSV 翻译文件则进行导出
	if dialogInit["OutputTranslationCsv"]:
		var outputCsvFile = File.new()
		outputCsvFile.open("res://" + fileName + ".csv", File.WRITE)
		
		for dialogCsvLine in dialogCsv:
			outputCsvFile.store_csv_line(dialogCsvLine, ",")
		
		outputCsvFile.close()
	
	# 如果要求导出 JSON 翻译文件则进行导出
	if dialogInit["OutputTranslationJson"]:
		var outputDict = {}
		
		var outputJsonFile = File.new()
		outputJsonFile.open("res://" + fileName + ".translation.json", File.WRITE)
		
		# 遍历写入字典
		for dialogCsvLine in dialogCsv:
			outputDict[dialogCsvLine[0]] = dialogCsvLine[1]
			
		var outputJsonRaw = JSON.print(outputDict)
		outputJsonFile.store_string(outputJsonRaw)
		outputJsonFile.close()


func parsingLine(line, index):
	var type = line[0] #类型
	
	# 如果不存在类型则忽略此行
	if type == "":
		return null
	
	# 复合型数据
	var paramsRaw = line[4]
	var data = {
		"character": line[1], # 角色
		"dialog": line[2], # 对话
		"sprite": line[3], # 立绘
		"params": parseParams(paramsRaw) # 参数解析
	}
	
	var result = {} #返回内容
	
	# 类型为初始化则进行初始化
	if type == "初始化":
		var parsed = JSON.parse(data["dialog"])
		dialogInit = parsed.get_result()
		return null
		
	if type.begins_with("注释"):
		return null
	
	# 不存在目标类型时返回
	if !dictEventsId.has(type):
		var typeRaw = type
		type = "文字"
		data["dialog"] = str(
			"[ Dialogic Builder :: Debug ]\nCan not found the target type ", typeRaw, " on Line ", index + 1,
			"\n", line
		)
		
	result.event_id = dictEventsId[type]
		
	match type:
		"文字":
			result = parseModuleText(result, data)
			
		"角色":
			result = parseModuleCharacter(result, data)
			
		"变量":
			result = parseModuleVariable(result, data)

		"主题":
			result.set_theme = themes[paramsRaw]

		"时间线":
			result.change_timeline = paramsRaw + ".json"

		"等待":
			result.hide_dialogbox = true
			result.wait_seconds = 1

			if paramsRaw != "":
				result.wait_seconds = int(paramsRaw)

		"背景":
			result = parseModuleBackground(result, data)

		"音效":
			result = parseModuleAudio(result, data)

		"音乐":
			result = parseModuleMusic(result, data)

		"信号":
			result.emit_signal = paramsRaw
	
	return result

# 解析“文字”类型
func parseModuleText(result, data):
	var character = data["character"]
	var dialog = data["dialog"]
	var sprite = data["sprite"]
	var params = data["params"]
	
	# 角色是否存在字典
	if characters.has(character):
		result.character = characters[character]
	else:
		result.character = ""
		
	# 如果使用角色语音：
	if dialogInit["UseCharacterSingleVoice"]:
		var voiceName = getValueFromParams(params, "voice", null)
		var volume = int(getValueFromParams(params, "volume", 0))
		var file = null
		
		if(voiceName == null and dialogInit["CharactersDefaultVoice"].has(character)):
			voiceName = dialogInit["CharactersDefaultVoice"][character]
			
		if voiceName != null:
			file = str(dialogInit["VoiceBaseURI"], character , "/", voiceName, ".ogg")
			result["voice_data"] = {}
			result["voice_data"]["0"] = {
				"audio_bus": dialogInit["VoiceBus"],
				"file": file,
				"volume": volume,
				"start_time": 0,
				"stop_time": 0
			}
		
	# 如果使用角色随机语音：
	if dialogInit["UseRandomVoice"]:
		var path = str(dialogInit["VoiceBaseURI"], character , "/")
		var filePath = null
		
		var files = getFilesFromFolder(path)
		if files.size() > 0:
			randomize()
			filePath = files[randi() % files.size()]
			result["voice_data"] = {}
			result["voice_data"]["0"] = {
				"audio_bus": dialogInit["VoiceBus"],
				"file": filePath,
				"start_time": 0,
				"stop_time": 0
			}
	
	# 如果使用翻译模式：
	if dialogInit["UseTranslation"]:
		var fillTr = dialogInit["TranslationFill"] % [5, dialogTextIndex]
		result.text = fillTr
		dialogTextIndex += 1
		
		# 如果要求导出翻译 CSV / JSON 文件：
		if dialogInit["OutputTranslationCsv"] or dialogInit["OutputTranslationJson"]:
			dialogCsv.append([fillTr, dialog])
		
	else:
		result.text = dialog
	
	result.portrait = sprite
	
	# 如果需要备份原始对话：
	if dialogInit["BackupOriginDialog"]:
		result.text_backup = dialog
		
	return result

# 解析“角色”类型
func parseModuleCharacter(result, data):
	var character = data["character"]
	var dialog = data["dialog"]
	var sprite = data["sprite"]
	var params = data["params"]

	var dictType = {"Enter": 0, "Leave": 1, "Update": 2}
	var dictPosition = {"0": false, "1": false, "2": false, "3": false, "4": false}

	# 更改角色的位置信息：
	var pos = getValueFromParams(params, "pos", false)
	if pos:
		var positionId = int(pos) - 1
		dictPosition[str(positionId)] = true
		result.change_position = true
		
	# 更改角色的 Z 轴信息：
	var z = getValueFromParams(params, "z", false)
	if z:
		result.change_z_index = true
		result.z_index = int(z)
		
	# 选定了某个角色：
	if character == "全部":
		result.character = "[ALL]"
	else:
		result.character = characters[character]

	# 角色状态（登场、离开、更新）
	var type = getValueFromParams(params, "type", false)
	if type:
		result.type = dictType[type]
	else:
		# 默认为更新状态
		result.type = dictType["Update"]

	result.position = dictPosition
	result.portrait = sprite
	
	return result

# 解析“背景”类型
func parseModuleBackground(result, data):
	var character = data["character"]
	var dialog = data["dialog"]
	var sprite = data["sprite"]
	var params = data["params"]
	
	result.background = str(dialogInit["BgImageBaseURI"], getValueFromParams(params, "url"), ".webp")
	result.fade_duration = int(getValueFromParams(params, "time", 1))
	
	return result

# 解析“音效”类型
func parseModuleAudio(result, data):
	var character = data["character"]
	var dialog = data["dialog"]
	var sprite = data["sprite"]
	var params = data["params"]
	
	result.audio = "play"
	result.audio_bus = dialogInit["AudioBus"]
	result.event_name = "AudioEvent"

	result.file = dialogInit["AudioBaseURI"] + getValueFromParams(params, "url", "") + ".ogg"
	result.volume = int(getValueFromParams(params, "volume", 0))
	
	return result

# 解析“音乐”类型
func parseModuleMusic(result, data):
	var character = data["character"]
	var dialog = data["dialog"]
	var sprite = data["sprite"]
	var params = data["params"]
	
	result["background-music"] = "play"
	result.audio_bus = dialogInit["MusicBus"]
	result.event_name = "BackgroundMusic"
	result.file = dialogInit["MusicBaseURI"] + getValueFromParams(params, "music", "")
	result.volume = int(getValueFromParams(params, "volume", 0))

	result.fade_length = 1
#	if other2 != "":
#		result.fade_length = other2
		
	return result

# 解析“变量”类型
func parseModuleVariable(result, data):
	var params = data["params"]
	
	result["operation"] = "="
	result["random_upper_limit"] = 100
	result["set_random"] = false
	result["definition"] = getValueFromParams(params, "id", "")
	result["set_value"] = getValueFromParams(params, "value", "")
		
	return result

func loadAllCharacters():
	var path = $Container/CharContainer/Edit.text + "/"
	var directory = Directory.new()
	
	if directory.open(path) != 0:
		print("Failed to load.")
		return
		
	var result = {}
		
	directory.list_dir_begin()
	var filePath = directory.get_next()
	
	# 遍历文件夹内的所有数据
	while filePath != "":
		# 获取的为文件夹则跳过
		if directory.current_is_dir():
			filePath = directory.get_next()
			continue
			
		# 目标文件不是 JSON 文件则跳过
		if !filePath.ends_with(".json"):
			filePath = directory.get_next()
			continue
			
		# 加载文件
		var file = File.new()
		file.open(path + filePath, File.READ)
		var jsonRaw = file.get_as_text()
		
		# 解析 JSON
		var json = JSON.parse(jsonRaw)
		var jsonData = json.get_result()
		
		# 加入用户信息
		var charName = jsonData.name
		var charId = jsonData.id
		result[charName] = charId
		
		# 关闭文件并进入下一个
		file.close()
		filePath = directory.get_next()
	
	characters = result
	
	return result

func loadAllThemes():
	var path = $Container/ThemeContainer/Edit.text + "/"
	var directory = Directory.new()
	
	if directory.open(path) != 0:
		print("Failed to load.")
		return
		
	var result = {}
		
	directory.list_dir_begin()
	var filePath = directory.get_next()
	
	# 遍历文件夹内的所有数据
	while filePath != "":
		# 获取的为文件夹则跳过
		if directory.current_is_dir():
			filePath = directory.get_next()
			continue
			
		# 目标文件不是 CFG 文件则跳过
		if !filePath.ends_with(".cfg"):
			filePath = directory.get_next()
			continue
			
		# 加载文件
		var config = ConfigFile.new()
		config.load(path + filePath)
		
		# 加入用户信息
		var name = config.get_value("settings", "name", "")
		var id = filePath
		result[name] = id
		
		# 进入下一个
		filePath = directory.get_next()
	
	themes = result
	
	return result
	
# 获取指定目录下的所有文件，默认返回 []
func getFilesFromFolder(path, directExtension = ".ogg"):
	var directory = Directory.new()
	
	if path == null:
		return []
	
	if directory.open(path) != 0:
		print("Failed to load folder: " + path)
		return []
		
	var result = []
		
	directory.list_dir_begin()
	var filePath = directory.get_next()
	
	# 遍历文件夹内的所有数据
	while filePath != "":
		# 获取的为文件夹则跳过
		if directory.current_is_dir():
			filePath = directory.get_next()
			continue
			
		# 目标文件不是 指定 文件则跳过
		if !filePath.ends_with(directExtension):
			filePath = directory.get_next()
			continue
			
		# 添加文件完整路径
		result.append(path + filePath)
		
		# 进入下一个
		filePath = directory.get_next()
	
	return result
	
func _on_ButtonBuilder_pressed():
	var csvFilePath = $Container/CsvContainer/Edit.text
	
	if csvFilePath == "":
		return
	
	builder()
	
	pass # Replace with function body.


func _on_ButtonLoadChar_button_up():
	$Container/CharContainer/FileDialogChar.current_dir = $Container/CharContainer/Edit.text
	$Container/CharContainer/FileDialogChar.popup_centered_ratio()
	pass # Replace with function body.


func _on_FileDialogChar_dir_selected(dir):
	$Container/CharContainer/Edit.text = dir
	
	$Container/CharContainer/CharsList.clear()
	
	var charsList = loadAllCharacters()
	for charKey in charsList.keys():
		var charValue = charsList[charKey]
		
		$Container/CharContainer/CharsList.add_item(str(charKey, " -> ", charValue))


func _on_ButtonLoadTheme_button_up():
	$Container/ThemeContainer/FileDialogTheme.current_dir = $Container/ThemeContainer/Edit.text
	$Container/ThemeContainer/FileDialogTheme.popup_centered_ratio()
	pass # Replace with function body.


func _on_FileDialogTheme_dir_selected(dir):
	$Container/ThemeContainer/Edit.text = dir
	
	$Container/ThemeContainer/ThemesList.clear()
	
	var themesList = loadAllThemes()
	for themeKey in themesList.keys():
		var themeValue = themesList[themeKey]
		
		$Container/ThemeContainer/ThemesList.add_item(str(themeKey, " -> ", themeValue))


func _on_FileDialogOutput_file_selected(path):
	$Container/OutputContainer/Edit.text = path
	pass # Replace with function body.


func parseParams(data_string: String, delimiter: String = ",", assignment: String = "=") -> Dictionary:
	var data = {}
	var key_value_pairs = data_string.split(delimiter)
	
	for pair in key_value_pairs:
		var key_value = pair.split(assignment)
		
		if key_value.size() == 1:
			var key = key_value[0].strip_edges()
			data[key] = true
		
		if key_value.size() == 2:
			var key = key_value[0].strip_edges()
			var value = key_value[1].strip_edges()
			data[key] = value
	
	return data

func getValueFromParams(data, key, default = ""):
	if !data.has(key):
		return default
		
	return data[key]
