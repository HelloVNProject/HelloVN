extends Control

export var buttonIcon : Resource = null
export var title : String = ""
export var isDarkMode: bool = false # 是否为夜间模式，夜间模式：白底黑字；日间模式：黑底白字

signal onClick

func _ready():
	switchStyle(self.isDarkMode)
		
	$Container/Title.text = title
	$Container/Button.texture_normal = buttonIcon
	$Container.rect_position.x = 0 - $Container.rect_size.x
		
	var tween = $Container/Tween
	Global.tweenBuilder(tween, $Container, "rect_position:x", 0, 1)
	tween.start()

func switchStyle(isDarkMode):
	if isDarkMode:
		$Container/BGLeft.color = Color.white
		$Container/BGRight.color = Color.white
		$Container/Button.modulate = Color.black
		$Container/Title.modulate = Color.black
	else:
		$Container/BGLeft.color = Color.black
		$Container/BGRight.color = Color.black
		$Container/Button.modulate = Color.white
		$Container/Title.modulate = Color.white


func _on_Button_mouse_entered():
	var tween = $Container/Tween
	tween.stop_all()
	
	var colors = [Color.white, Color.black]
	
	if isDarkMode:
		colors = [Color.black, Color.white]
		
	var containerWidth = $Container.rect_size.x
	
	Global.tweenBuilder(tween, get_node("Container/BGHover"), "rect_size:x", containerWidth, 1)
	Global.tweenBuilder(tween, get_node("Container/BGHover"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node("Container/Button"), "modulate", colors[1], 1)
	Global.tweenBuilder(tween, get_node("Container/Title"), "modulate", colors[1], 1)
	
	tween.start()


func _on_Button_mouse_exited():
	var tween = $Container/Tween
	tween.stop_all()
	
	var colors = [Color.black, Color.white]
	
	if isDarkMode:
		colors = [Color.white, Color.black]
	
	var containerWidth = $Container.rect_size.x
	
	Global.tweenBuilder(tween, get_node("Container/BGHover"), "rect_size:x", 0, 1)
	Global.tweenBuilder(tween, get_node("Container/BGHover"), "color", colors[0], 1)
	Global.tweenBuilder(tween, get_node("Container/Button"), "modulate", colors[1], 1)
	Global.tweenBuilder(tween, get_node("Container/Title"), "modulate", colors[1], 1)
	
	tween.start()


func _on_Title_resized():
	var mixedSizeX = $Container/Title.rect_position.x + $Container/Title.rect_size.x
	
	$Container/BGLeft.rect_size.x = mixedSizeX + 40
	$Container/BGRight.rect_position.x = mixedSizeX + 60
	$Container.rect_size.x = $Container/BGRight.rect_position.x + 20


func _on_Button_pressed():
		emit_signal("onClick")

