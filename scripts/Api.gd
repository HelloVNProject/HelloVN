extends Node

const BaseURL: String = "https://hellovn.wsm.ink/api"

## 内部请求
## path: 基于 BaseURL 的路径，不包括 BaseURL，以 / 开头
## method: 请求方式，使用时统一使用 METHOD_ 常量
## headers: 请求头对象
## params: 请求参数对象
## data: 请求体数据，需要使用对象/数组
## return {code: Int, data: Object}
func innieRequest(path, method = HTTPClient.METHOD_GET, headers = {}, params = {}, data = {}):
	var url = str(BaseURL, path, "?")
	
	# 遍历参数的键值对到 url 里
	for key in params.keys():
		var value = params[key]
		url += str(key, "=", value, "&")
		
	#  data 数据转 raw
	var rawData = JSON.print(data)
	
	# 遍历请求头的键值对
	var headersRaw = PoolStringArray()
	for key in headers.keys():
		var value = headers[key]
		headersRaw.append(str(key, ":", value))
	
	# 建立 HTTP 实例
	var http = HTTPRequest.new()
	add_child(http)
	
	# 发送请求，如果回调失败则返回 code: 0
	var error = http.request(url, headersRaw, true, method, rawData)
	if error != OK:
		remove_child(http)
		return {"code": 0}
		
	# 否则拿到 response
	var response = yield(http, "request_completed")
	var body = response[3].get_string_from_utf8()
	
	remove_child(http)
	
	# 如果服务器错误则返回
	if !("code" in body):
		remove_child(http)
		return {"code": 0}
	
	# 返回解析到对象的结果
	return parse_json(body)

## 内部获取设备唯一ID
func innieGetDeviceId():
	var deviceId = OS.get_unique_id()
	deviceId = deviceId.replace("{", "").replace("}", "")
	
	return deviceId
	
## 获取游戏最新版（自动判定客户端模式：发行版/调试版）
## userVersion: 用户本地版本号
## return {code: Int, data: {hasNewVersion: Bool, version: String, downloadUrl: String, note: String}}
func getLatestVersion(userVersion):
	var dev = "/dev" if !isProduction() else "/"
	
	var method = HTTPClient.METHOD_GET
	var path = "/v1/versions/latest" + dev
	var params = {
		"userVersion": userVersion
	}
	
	return yield(innieRequest(path, method, {}, params), "completed")

## 获取节点数据
## chapter: 获取指定章节前的节点数据
## return {code: Int, data: {nodes: Array}}
func getNodes(chapter):
	var method = HTTPClient.METHOD_GET
	var path = "/v1/nodes"
	var params = {
		"chapter": chapter
	}
	
	return yield(innieRequest(path, method, {}, params), "completed")

## 批量添加用户达成的 QTE 节点
## qtesData: 用户的 QTE 节点数据列表，[{nodeId: Int, choice: Int, details: Object}, ...]
## return {code: Int, data: {nodes: Object}}
func batchInsertUserQTEs(qtesData):
	var method = HTTPClient.METHOD_POST
	var path = "/v1/nodes/qtes"
	var headers = {
		"Content-Type": "application/json",
		"Player-Device-Id": innieGetDeviceId()
	}
	
	return yield(innieRequest(path, method, headers, {}, qtesData), "completed")

## 用户登记
## data: JSON 数据，{deviceId, email, subcribe, twoFa, saveData, settingData}
## return {code: Int, data: {...}}
func register(data):
	var method = HTTPClient.METHOD_POST
	var path = "/v1/players"
	var headers = {
		"Content-Type": "application/json"
	}
	
	return yield(innieRequest(path, method, headers, {}, data), "completed")

# 该游戏客户端是否为发行版客户端
func isProduction():
	return OS.has_feature("release")
