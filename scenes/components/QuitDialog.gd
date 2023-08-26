extends Control

func _ready():
	$Dialog.popup_centered()

func _on_Dialog_confirmed():
	get_tree().call("quit")


func _on_Dialog_popup_hide():
	get_tree().call("quit")
