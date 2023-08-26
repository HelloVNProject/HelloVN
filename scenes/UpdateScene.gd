extends Control

var latest
var localFile
#const localPckPath = "res://HelloVN.pck"
#const localApkPath = "user://HelloVN.apk"

func _ready():
	$HasNew.visible = false
	
	$Checking.rect_position.y = 1080
	
	$Tween.interpolate_property($Checking, "rect_position:y", 1080, 1032, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 1)
	$Tween.start()
	
	latest = yield(Updater.checkHasNewVersion(), "completed")
	
	# 获取版本信息失败：
	if !latest:
		failedToGetLatest()
		return

	var hasNewVersion = latest.hasNewVersion
	
	$Tween.interpolate_property($Checking, "rect_position:y", 1032, 1080, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 5)
	$Tween.start()
		
	# 已是最新版：
	if !hasNewVersion:
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Checking/Text.text = tr("TR:UPDATE:NOUPDATE")
		return

	Global.IsMenuSubMenu = true
		
	$HasNew.visible = true
	$HasNew/BlurBG.visible = true
		
	var body = latest.body
	var text = body
	
	var latestVersion = latest.latestVersion
	var localVersion = latest.localVersion
	var fileSize = latest.fileSize if !Global.isAndroid() else latest.fileSizeApk
	var fileSizeReadable = Global.formatFileSize(fileSize)
	var androidTip = ""
	if Global.isAndroid():
		androidTip = str("[b][color=#F00]", tr("TR:UPDATE:ANDROIDTIP"), "[/color][/b]\n\n")

	$HasNew/Container/Version.text = str(
		tr("TR:UPDATE:LOCALVERSION"), " ", localVersion, "\n",
		tr("TR:UPDATE:LATESTVERSION"), " ", latestVersion, "\n",
		tr("TR:UPDATE:FILESIZE"), " ", fileSizeReadable, "\n"
	)
	
	$HasNew/Container/Text.bbcode_text = str(androidTip, text)

func _exit_tree():
	Global.IsMenuSubMenu = false

func failedToGetLatest():
	$HasNew/Container/ButtonContainer/ButtonClose.visible = true
	$HasNew.visible = true
	$HasNew/BlurBG.visible = true
	$HasNew/Container/ButtonContainer/ButtonUpdate.visible = false
	
	var latestVersion = tr("TR:UPDATE:UNKNOWN")
	var localVersion = Updater.getGameVersion()

	$HasNew/Container/Version.text = str(
		tr("TR:UPDATE:LOCALVERSION"), "   ", localVersion, "\n",
		tr("TR:UPDATE:LATESTVERSION"), "   ", latestVersion, "\n",
		tr("TR:UPDATE:FILESIZE"), " ", tr("TR:UPDATE:UNKNOWN")
	)
	
	$HasNew/Container/Title.text = tr("TR:UPDATE:FAIL:TITLE")
	$HasNew/Container/Text.bbcode_text = tr("TR:UPDATE:FAIL:TEXT")

func _on_ButtonClose_pressed():
	$Downloader.cancel_request()
	$DownloaderTimer.stop()
	
	self.visible = false


func _on_ButtonUpdate_pressed():
	# Android 版让用户自己前往浏览器下载
	if Global.isAndroid():
		OS.shell_open(latest.downloadUrlApk)
		return
	
	var downloadLink = latest.downloadUrl
	
	localFile = "res://HelloVN.pck"
	if !Api.isProduction():
		localFile = "res://HelloVN-debug.pck"
	
	$HasNew/Container/ButtonContainer.visible = false
	$HasNew/Container/Title.text = tr("TR:UPDATE:UPDATING")
	
	$Downloader.set_download_file(localFile)
	$Downloader.request(downloadLink)
	
	$DownloaderTimer.start()


func _on_DownloaderTimer_timeout():
	var downloaded = $Downloader.get_downloaded_bytes()
	var all = $Downloader.get_body_size()
	var progress = (downloaded * 1.0) / all
	
	var screenMaxX = 1920
	var progressNowX = screenMaxX * progress
	
	var progressX = $HasNew/Progress.rect_size.x
	
	$HasNew/Progress/Label.text = str("%3.2f" % (progress * 100), "%")
	
	$Tween.interpolate_property($HasNew/Progress, "rect_size:x", progressX, progressNowX, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	
	if progress == 1:
		$HasNew/Progress/ButtonClose.visible = true
		$HasNew/Progress/Label.text = tr("TR:UPDATE:UPDATED")
		$DownloaderTimer.stop()




func _on_ButtonCloseGame_pressed():
	get_tree().quit()


func _on_Text_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.
