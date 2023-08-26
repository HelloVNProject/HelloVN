extends Node

# 获取游戏版本
func getGameVersion():
	return ProjectSettings.get_setting("application/config/version")

# 检查游戏是否存在新版
# result：{"success": true, "hasNewVersion": true, "version": "...", "downloadUrl": "...", "body": "..."}
func checkHasNewVersion():
	var localVersion = getGameVersion()
	
	var response = yield(Api.getLatestVersion(localVersion), "completed")
	var code = response.code
	
	if code != 300:
		return false
		
	var data = response.data
	data["localVersion"] = localVersion
	
	if data.has("version"):
		data["latestVersion"] = data.version
	
	if data.has("body"):
		data["body"] = noteParsing(data.body)
	
	return data


# 解析 Note
# Result: Body
func noteParsing(notesRaw):
	var locale = TranslationServer.get_locale()
	var notes = notesRaw.split("-----")
	var body
	
	if locale.begins_with("zh"):
		body = notes[0].strip_edges()
	else:
		body = notes[1].strip_edges()
	
	return body
	
	
	
	
	
	
	
	
	
	
