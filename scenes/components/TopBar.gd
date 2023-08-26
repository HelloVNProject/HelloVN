extends Control
export var title: String = ""
export var duration: int = 3


func _ready():
	$Container.rect_position.y = -45
	$Container/Title.text = title
	
	var tween = $Tween
	Global.tweenBuilder(tween, $Container, "rect_position:y", 0, 1)
	tween.start()
	
	yield(get_tree().create_timer(duration), "timeout")
	
	Global.tweenBuilder(tween, $Container, "rect_position:y", -45, 1)
	tween.start()
	
	yield(get_tree().create_timer(1), "timeout")
	
	queue_free()
	

