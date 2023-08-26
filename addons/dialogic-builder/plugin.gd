tool
extends EditorPlugin

var dockMain: Node

func _enter_tree():
	dockMain = preload("res://addons/dialogic-builder/Main.tscn").instance()
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UR, dockMain)
	
	pass


func _exit_tree():
	remove_control_from_docks(dockMain)
	
	dockMain.free()
	
	pass

func _on_ButtonLoad_pressed():
	print("press")
	$FileDialog.popup()
	
	pass # Replace with function body.
