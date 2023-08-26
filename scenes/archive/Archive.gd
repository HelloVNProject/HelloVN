extends Control
export var useTitleButton: bool = true

const trNodePrefix = "TR:NODE:"

var qteBoxHeight: int

# 鼠标是否按下 或 是否触摸中
var isMouseTouchDown: bool = false

# 上一帧的 Y 值
var lastFrameYPos = null

func _ready():
	$TempBG.visible = false
	$Templates.visible = false
	
	var title = preload("res://scenes/components/PageTitle.tscn").instance()
	title.title = "TR:NODE:TITLE"
	
	if useTitleButton:
		title.buttonIcon = load("res://images/icons/left.png")
		
	self.add_child(title)
	
	var latestChapter = Global.getUserLatestChapter()
	var nodesData = parseExcel(latestChapter)
	
	for nodeData in nodesData:
		renderANode(nodeData)

func getNodesRoot(chapter):
	var http = HTTPRequest.new()
	add_child(http)
	
	var url = str(Global.BackendApi, "/v1/nodes?chapter=", chapter)
	var error = http.request(url)
	
	if error != OK:
		remove_child(http)
		return {"code": 101}
		
	var response = yield(http, "request_completed")
	var body = response[3]
	
	remove_child(http)
	
	return parse_json(body.get_string_from_utf8())


# 渲染一个节点
func renderANode(nodeData):
	var type = nodeData.type # Timeline, QTE
	
	if type == "Timeline":
		return renderANodeAsTimeline(nodeData)
	if type == "QTE":
		return renderANodeAsQte(nodeData)
	
	
# 渲染一个时间线节点
func renderANodeAsTimeline(nodeData):
	var id = nodeData.id # MOD:1.01:1000
	var route = nodeData.route # TSR, MOD
	var eventTime = nodeData.timelineEventTime # 10:00:00
	var level = nodeData.timelineLevel # General, Important, Urgent
	
	var path = str("Timeline/Margin/HBox/", route)
	
	var nodeCloned = get_node(str("Templates/", route, "/", level)).duplicate()
	nodeCloned.set_name(str("Node", id))
	nodeCloned.get_node("Content/Text").connect("resized", self, "_on_content_resized", [path, nodeCloned.name])
	
	# 解析文字
	var text = tr(str(trNodePrefix, id, ":TEXT"))
	
	# 如果为烟室路径则右对齐
	if route == "TSR":
		text = str("[right]", text, "[/right]")
	
	# 渲染文字
	nodeCloned.get_node("Content/Text").bbcode_text = text
	
	# 解析并渲染时间
	var eventTimeParsed = parsingEventTime(eventTime)
	nodeCloned.get_node("Content/Datetime").text = eventTimeParsed
	
	# 如果为 Urgent 则解析时间
	if level == "Urgent":
		nodeCloned.get_node("BigTime").text = str(" ", eventTimeParsed, " ")
	
	get_node(path).add_child(nodeCloned)


# 渲染一个 QTE 节点
func renderANodeAsQte(nodeData):
	var id = nodeData.qteTitle
	var route = nodeData.route # 1: TSR, 2: MOD
	var amountAllPlayers = nodeData.qteAmountAllPlayers # QTE All Players Amount (8)
	var amountChoices = nodeData.qteAmountChoices # QTE Choices List ([4, 2, 2])
	
	# 路径字典及解析
	var routeDict = [ "Tsr", "Mod" ]
	var routeStr = routeDict[route - 1]
	
	var nodeCloned = get_node(str("Templates/", routeStr, "/Qte")).duplicate()
	nodeCloned.set_name(str("Node", id))
	
	# 解析 QTE 标题
	var title = tr(str(trNodePrefix, id, ":TITLE"))
	nodeCloned.get_node("Box/Title/Marign/Label").text = title
	
	# 遍历渲染选择列表
	var i = 1
	for amountChoice in amountChoices:
		var rowNodeCloned = get_node(str("Templates/", routeStr, "/QteRowMiss")).duplicate()
		
		# 解析进度
		var progress = 0
		if amountChoice > 0:
			progress = round((amountChoice * 1.0 / amountAllPlayers) * 100)
			
		rowNodeCloned.get_node("Progress").text = str(progress, "%")
		
		# 解析单个选择的标题
		var singleTitle = tr(str(trNodePrefix, id, ":", i, ":TITLE"))
		rowNodeCloned.get_node("Text").text = singleTitle
		
		nodeCloned.get_node("Box/Content").add_child(rowNodeCloned)
		
		# 更新此节点的高度
		nodeCloned.rect_min_size.y += 64
		
		i = i + 1
		
	# 添加盒子底部的 Border
	nodeCloned.get_node("Box/Content").add_child($Templates/Mod/QteRowBottomBorder.duplicate())
	
	# 更新此节点的高度
	nodeCloned.rect_min_size.y += 34
	nodeCloned.get_node("LinkLine").rect_min_size.y = nodeCloned.rect_min_size.y
#
	get_node(str("Timeline/Margin/HBox/", routeStr)).add_child(nodeCloned)


func parsingEventTime(eventTime):
	# 以 TR 开头则返回
	if(eventTime.begins_with("TR")):
		return eventTime
		
	# 不以 before & after 开头则返回
	if(!eventTime.begins_with("before") and !eventTime.begins_with("after")):
		return eventTime
	
	var eventTimeSplit = eventTime.split(" ") # before 10:00:00
	var end = tr(str("TR:SYSTEM:TIME:", eventTimeSplit[0].to_upper())) # Ago, Later
	
	var timeSplit = eventTimeSplit[1].split(":")
	var timeParsed = ""
	
	var timeDict = [ "HOUR", "MINUTE", "SECOND" ]
	
	var i = 0
	for time in timeSplit:
		# 如果时间为 0 则跳过
		if time == "0" or time == "00":
			continue
			
		var timeExtTred = tr(str("TR:SYSTEM:TIME:", timeDict[i]))
		timeParsed += str(time, " ", timeExtTred)
		
	return str(timeParsed, " ", end)

# 解析 Archives 文件
func parseExcel(latestChapter):
	var data = Const.parsingCsvFile("res://excels/archives.csv", false, true)[1]
	var result = []
	
	for line in data:
		# 如果已经遍历完毕则跳出循环
		if line[0] == "":
			break
		
		var route = line[0] # MOD
		var chapterPart = float(line[1]) # 1.01
		var id = line[2] # 1000
		var level = line[3] # General, Important, Urgent, QTE
		var time = line[4] # 10:00:00
		
		# 如果 level 为 QTE 则表示 QTE，否则表示 Timeline
		var type = "QTE" if level == "QTE" else "Timeline"
		
		# MOD:1.01:1000
		var trId = str(route, ":", chapterPart, ":", id)
		
		# 如果该节点未解锁，则跳过
		if float(chapterPart) > latestChapter:
			continue
			
		result.append({
			"id": trId,
			"route": route,
			"type": type,
			"chapterPart": chapterPart,
			"timelineEventTime": time,
			"timelineLevel": level,
		})
		
	return result
	
func _on_content_resized(path, name):
	var nodePath = str(path, "/", name)
	var node = get_node(nodePath)
	
	var nodeHeight = node.get_node("Content/Text").rect_size.y
	var fixedHeight = nodeHeight + 100
	node.rect_min_size.y = nodeHeight + 100
	
	node.get_node("LinkLine").rect_size.y = fixedHeight


func _on_Timeline_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			isMouseTouchDown = true
		elif event.button_index == 1 and not event.is_pressed():
			isMouseTouchDown = false
			
			# 不触碰后别忘记删除上一帧的 Y Pos
			lastFrameYPos = null

func _process(delta):
	if isMouseTouchDown:
		var y = get_viewport().get_mouse_position().y
		
		# 如果 Y Pos 为 null 则进行一个更新
		if lastFrameYPos == null:
			lastFrameYPos = y
			return
		
		# 从第二帧开始更新滚动条位置
		var fixedY = (lastFrameYPos - y) / 2
		$Timeline.scroll_vertical_fixed(fixedY)
		
		# 最后更新当前 Y pos 全局变量
		lastFrameYPos = y
		
		
	
	pass
