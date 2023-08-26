extends Control
export var chapterId : String = ""

func _ready():
	$BG.texture = load(str("res://images/endings/", chapterId, "/image.webp"))
	
	var temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.title = "TR:ENDING:BUTTON:NEXT"
	temp.icon = load("res://images/icons/next.png")
	temp.connect("onClick", self, "_on_left_button_click")
	self.add_child(temp)
	
	var part2 = preload("res://scenes/chapter-end/Part2.tscn").instance()
	part2.chapterId = chapterId
	self.add_child(part2)
	get_node("Part2").rect_position.y = 1080
	
func _on_left_button_click():
	var tween = $Tween
	Global.tweenBuilder(tween, $BG, "rect_position:y", -540, 2)
	Global.tweenBuilder(tween, $Part2, "rect_position:y", 0, 1.5)
	Global.tweenBuilder(tween, $PageButton, "modulate", Color.transparent, 1.5)
	tween.start()
	
	$Part2.init()
