extends Control

export var id : String = "" # 数据流对象 ID
export var isDarkMode: bool = false # 是否为夜间模式，夜间模式：白底黑字；日间模式：黑底白字

var countdown = 5 # 倒计时时间，每秒 -1

func _ready():
	var data = Const.BelongsToasts[id]
	
	for key in data:
		var values = data[key]
		var titleName = tr("TR:BELONGS:" + key.to_upper())
		var title = str(titleName, "// ")
		
		for value in values:
			title += value + "  "
		
		var temp = $Templates/IconTitle
		temp.get_node("Icon").texture = load(str("res://images/icons/belongs/", key, ".png"))
		temp.get_node("Title").text = title
		
		$Left/Belongs.add_child(temp.duplicate())
		
	$Left.rect_position.x = 0 - $Left.rect_size.x
	
	var tween = $Left/Tween
	Global.tweenBuilder(tween, $Left, "rect_position:x", 0, 1)
	tween.start()


func _on_Timer_timeout():
	countdown -= 1
	
	if countdown == 0:
		var tween = $Left/Tween
		Global.tweenBuilder(tween, $Left, "modulate", Color.transparent, 2)
		tween.start()
	
		yield(Global.sleep(2), "completed")
	
		self.queue_free()

