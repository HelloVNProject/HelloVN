extends Control
export var chapterId : String = ""

func init():
	$Main/BGTemp.visible = false
	$Main/Temps.visible = false
	
	$Main/Header.texture = load(str("res://images/endings/", chapterId, "/header.webp"))
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var title = preload("res://scenes/components/PageTitle.tscn").instance()
	title.title = tr(str("TR:CHAPTER:", chapterId, ":NAME"))
	$Main.add_child(title)
	
	var chapter = int(chapterId.split(".")[0])
	var fieldChapterPlayedTime = str("Chapter", chapter, "PlayedTime")
	var chapterPlayedTime = Global.formatTime(int(Dialogic.get_variable(fieldChapterPlayedTime, 0)))
	
	var fieldFullPlayedTime = str("PlayedTime")
	var fullPlayedTime = Global.formatTime(int(Dialogic.get_variable(fieldFullPlayedTime, 0)))
	
	var cards = [
		{
			"name": "Finished",
			"icon": "chapter-finished.png",
			"caption": tr("TR:ENDING:FINISHED"),
			"content": tr(str("TR:CHAPTER:", chapterId, ":CAPTION"))
		},
		{
			"name": "PlayedTime",
			"icon": "chapter-played-time.png",
			"caption": tr("TR:ENDING:CHAPTERPLAYEDTIME"),
			"content": str(chapterPlayedTime)
		},
		{
			"name": "AllPlayedTime",
			"icon": "chapters-played-time.png",
			"caption": tr("TR:ENDING:PLAYEDTIME"),
			"content": str(fullPlayedTime)
		},
	]
	
	var delay = 0
	for card in cards:
		var icon = load(str("res://images/icons/", card.icon))
		buildACard(card.name, icon, card.caption, card.content, delay)
		delay += 0.5
	
	yield(get_tree().create_timer(delay + 0.5), "timeout")
	
	var temp = preload("res://scenes/components/PageButton.tscn").instance()
	temp.title = tr("TR:ENDING:BUTTON:TOREGISTER")
	temp.icon = load("res://images/icons/next.png")
	temp.connect("onClick", self, "_on_left_button_click")
	$Main.add_child(temp)
	
	var register = preload("res://scenes/chapter-end/Register.tscn").instance()
	register.rect_position.y = 1080
	self.add_child(register)


# 构建一个卡片
# name: 卡片唯一名
# icon: 卡片图标
# caption: 卡片标题
# content: 卡片内容
func buildACard(name: String, icon: Resource, caption: String, content: String, delay: float = 0):
	var card : Node = $Main/Temps/Card.duplicate()
		
	card.name = name
	card.modulate = Color.transparent
	card.get_node("Icon").texture = icon
	card.get_node("Caption").text = caption
	card.get_node("Content").text = content
	
	$Main/Cards/Container.add_child(card)
	
	var buildedCard = get_node("Main/Cards/Container/" + name)
	var tween = buildedCard.get_node("Tween")
	Global.tweenBuilder(tween, buildedCard, "modulate", Color.white, 2, delay)
	tween.start()

func _on_left_button_click():
	var tween = $Tween
	Global.tweenBuilder(tween, $Register, "rect_position:y", 0, 1)
	Global.tweenBuilder(tween, $Main, "rect_position:y", -1080, 1)
	tween.start()
	
	$Register.init()
