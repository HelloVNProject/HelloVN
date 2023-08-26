extends Control


func _ready():
	$Block/Text.modulate = Color.transparent
	$Block/BG.rect_size.x = 0
	$Block/Right.rect_size.x = 0


func _on_Text_item_rect_changed():
	var height = $Block/Text.rect_size.y + 10
	var textPosY = $Block/Text.rect_position.y - 5
	
	$Tween.interpolate_property($Block/BG, "rect_size:y", $Block/BG.rect_size.y, height, 1,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property($Block/BG, "rect_position:y", $Block/BG.rect_position.y, textPosY, 1,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	$Tween.interpolate_property($Block/Right, "rect_size:y", $Block/Right.rect_size.y, height, 1,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property($Block/Right, "rect_position:y", $Block/Right.rect_position.y, textPosY, 1,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	

