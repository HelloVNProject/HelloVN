extends Control


func _ready():
	var latestChapter = Global.getUserLatestChapter()
	if(latestChapter >= 1.01):
		$Parallax/ParallaxGuys.visible = true
	
	pass # Replace with function body.
