extends Control

onready var tree = $MenuContainer/Tree

var config = Global.loadConfigs()
#
var extraData = Const.getExtraData()

var latestChapter = Global.getUserLatestChapter()

func _ready():
	$BothControl.visible = false
	$PictureControl.visible = false
	$ArticleControl.visible = false

	var rootTree = tree.create_item()

	for extra in extraData:
		var id = extra.id
		print(id)
		var name = tr(extra.name)
		var items = []

		if extra.has("items"):
			items = extra.items
#
		var parent = tree.create_item(rootTree)
		parent.set_metadata(0, {"type": "parnet", "id": id})
		parent.set_text(0, name)
		insertChildsToTree(parent, items)
		
	var title = preload("res://scenes/components/PageTitle.tscn").instance()
	title.title = "TR:EXTRA:TITLE"
	title.buttonIcon = load("res://images/icons/left.png")
	self.add_child(title)
	
	
# 添加父节点的子节点到树
func insertChildsToTree(parent, items):
	for i in items.size():
		var item = items[i]
		var id = item.id
		var name = tr(item.name)
		
		var child = tree.create_item(parent)
		child.set_metadata(0, {"type": "child", "id": id})
		child.set_text(0, name)
	

func _on_Title_resized():
	var width = $TitleContainer/Title.rect_size.x
	var fixedWidth = 102 + width + 16
	
	$TitleContainer/BG.rect_size.x = fixedWidth
	$TitleContainer/Right.rect_position.x = fixedWidth + 32


func _on_Tree_item_selected():
	var extraDetailData = Const.getExtraData(true)
	
	$BothControl.visible = false
	$PictureControl.visible = false
	$ArticleControl.visible = false
	
	var meta = $MenuContainer/Tree.get_selected().get_metadata(0)
	var id = meta.id
	
	# 字典不存在指定键则直接返回
	if !extraDetailData.has(id):
		return
	
	var data = extraDetailData[id]
	var render = data.render
	
	if data.has("cellTranslate"):
		var descRaw = data.descRaw
		var trLength = descRaw.countn("TR")
		
		var cells = Global.searchAllRegex(descRaw, "\\[cell\\]", "\\[/cell\\]")
		
		for cell in cells:
			var cellName = cell.get_string(2).replace("[b]", "").replace("[/b]", "")
			var cellTred = tr(cellName)
			descRaw = descRaw.replace(cellName, cellTred)
			
		data.desc = descRaw
	
	if render == "both":
		renderBothStyle(data)
	if render == "picture":
		renderPictureStyle(data)
	if render == "article":
		renderArticleStyle(data)

# 渲染图文并茂风格
func renderBothStyle(data):
	var name = tr(data.name)
	var subname = tr(data.subname)
	var desc = tr(data.desc)
	var sprite = data.pic
	var unlockChapter = 0
	var extras = []
	
	if data.has("extras"):
		extras = data.extras
	
	if data.has("unlockChapter"):
		unlockChapter = data.unlockChapter
	
	for i in extras.size():
		var extra = extras[i]
		var chapter = extra.chapter
		var content = tr(extra.content)
		
		var chapterInvest = tr("TR:EXTRA:CHAPTERINVEST")
		
		# 检查目标章节是否已通关
		var chapterHasFinished = latestChapter >= chapter
		var contentFixed = tr("TR:EXTRA:NEEDUNLOCK")
		if chapterHasFinished:
			contentFixed = content
			
		var chapterSplit = str(chapter).split(".")
		var chapterOnly = chapterSplit[0]
		var chapterPart = chapterSplit[1]
		
		desc += "\n\n"
		desc += Global.parseTexts(str("[b]", chapterInvest, "[/b]"), 
			{"chapter": chapterOnly, "part": chapterPart})
		desc += contentFixed
	
	# 初始化数据
	$BothControl/NameTitle.text = name
	$BothControl/NameSubtitle.text = subname
	$BothControl/TextContainer/Description.bbcode_text = desc
	$BothControl/SpriteControl/Sprite.texture = load(sprite)
	$BothControl/SpriteControl/BG.rect_scale = Vector2(0, 0)
	$BothControl/SpriteControl/Rounds.rect_scale = Vector2(0, 0)
	
	# 检查目标章节是否已通关，如果没有通关则禁用 sprite 和 content
	var chapterHasFinished = latestChapter >= unlockChapter
	if !chapterHasFinished:
		var chapterInvest = tr("TR:EXTRA:NEEDUNLOCK:PARAMS")
		var chapterSplit = str(unlockChapter).split(".")
		var chapterOnly = chapterSplit[0]
		var chapterPart = chapterSplit[1] 
		
		$BothControl/SpriteControl/Sprite.texture = load("res://images/no-image.png")
		$BothControl/TextContainer/Description.bbcode_text = Global.parseTexts(chapterInvest, 
			{"chapter": chapterOnly, "part": chapterPart})
	
	$BothControl.visible = true
	
	var tween = $BothControl/Tween
	
	# 渲染名字
	tween.interpolate_property($BothControl/NameTitle, "percent_visible", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property($BothControl/NameSubtitle, "percent_visible", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.5)
	
	# 渲染介绍
	tween.interpolate_property($BothControl/TextContainer/Description, "percent_visible", 0, 1, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	# 渲染立绘
	tween.interpolate_property($BothControl/SpriteControl/Rounds, "rect_scale", Vector2(0, 0), Vector2(1, 1), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property($BothControl/SpriteControl/BG, "rect_scale", Vector2(0, 0), Vector2(1, 1), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property($BothControl/SpriteControl/Sprite, "modulate", Color.transparent, Color.white, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.3)
	
	tween.start()
	
# 渲染大图风格
func renderPictureStyle(data):
	var name = tr(data.name)
	var content = tr(data.content)
	var chapter = data.chapter
	var picture = data.pic
	
	var titleFixed = ""
	var contentFixed = ""
	var pictureFixed = "res://images/no-image.png"
	
	# 检查目标章节是否已通关
	var chapterHasFinished = latestChapter >= chapter
	if chapterHasFinished:
		titleFixed = str(tr("TR:SYSTEM:QUOTE:LEFT"), name, tr("TR:SYSTEM:QUOTE:RIGHT"))
		contentFixed = content
		pictureFixed = picture
	else:
		var chapterInvest = tr("TR:EXTRA:NEEDUNLOCK")
		var chapterSplit = str(chapter).split(".")
		var chapterOnly = chapterSplit[0]
		var chapterPart = chapterSplit[1]
		
		titleFixed = Global.parseTexts(chapterInvest, 
			{"chapter": chapterOnly, "part": chapterPart})
	
	$PictureControl/Title.text = titleFixed
	$PictureControl/Artist.text = contentFixed
	$PictureControl/Picture.texture = load(pictureFixed)
	
	$PictureControl.visible = true

# 渲染文章风格
func renderArticleStyle(data):
	var tween = $ArticleControl/Tween
	var title = tr(data.name)
	var desc = tr(data.desc)
	
	$ArticleControl/Title.text = title
	$ArticleControl/Description.bbcode_text = desc
	
	$ArticleControl.visible = true
	
	# 渲染文字
	tween.interpolate_property($ArticleControl/Title, "percent_visible", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property($ArticleControl/Description, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.25)
	
	tween.start()
	
	
func _on_Description_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.



func _on_Extra_hide():
	$MenuContainer/Tree.clear()
	
	pass # Replace with function body.
