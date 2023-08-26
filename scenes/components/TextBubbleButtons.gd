extends Control

func _on_Option_pressed():
	$BlurBG.visible = true
	var scene = load("res://scenes/Setting.tscn").instance()
	scene.rect_position = Vector2(0, 0)
	self.add_child(scene)
	get_node("Setting/PageTitle/Container/Button").connect("pressed", self, "_on_SettingBackButton_pressed")

func _on_SettingBackButton_pressed():
	$BlurBG.visible = false
	self.remove_child($Setting)


func _on_Menu_pressed():
	pass # Replace with function body.
