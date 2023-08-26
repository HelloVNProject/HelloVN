extends Control

var timeout = 10

func _on_Close_pressed():
	get_tree().call("quit")


func _on_Next_pressed():
	# 如果不再显示 Splash：
	if $Marign/VBox/DoNotShow.pressed:
		Global.saveConfig("System", "SplashHidden", true)
	
	self.visible = false


func _on_Timer_timeout():
	timeout -= 1
	
	if timeout <= 0:
		$Timer.stop()
		return
	
	$Marign/VBox/Content.bbcode_text = tr("TR:SPLASH:CONTENT")
	
