extends Node
class_name Languages

func init():
	var localesBaseUrl = "res://locales"
	var localesPath = getFoldersFromFolder(localesBaseUrl)
	
	# 遍历每一个语言文件夹：
	for localePath in localesPath:
		# 遍历每一个语言文件夹里 PO 文件并添加到语言服务器
		var filesPath = getFilesFromFolder(localePath, "po")
		for filePath in filesPath:
			TranslationServer.add_translation(load(filePath))

# 获取指定目录下的所有文件，默认返回 []
func getFilesFromFolder(path, directExtension):
	var directory = Directory.new()
	
	if path == null:
		return []
	
	if directory.open(path) != 0:
		print("Failed to load folder: " + path)
		return []
		
	var result = []
		
	directory.list_dir_begin()
	var filePath = directory.get_next()
	
	# 遍历文件夹内的所有数据
	while filePath != "":
		# 目标文件是 指定 文件
		if filePath.ends_with(directExtension):
			# 添加文件完整路径
			result.append(str(path, "/", filePath))
		
		# 进入下一个
		filePath = directory.get_next()
	
	return result

# 获取指定目录下的所有子目录（包括 path），默认返回 []
func getFoldersFromFolder(path): 
	var directory = Directory.new()
	
	if path == null:
		return []
	
	if directory.open(path) != 0:
		print("Failed to load folder: " + path)
		return []
		
	var result = []
		
	directory.list_dir_begin()
	var fileName = directory.get_next()
	while fileName != "":
		if directory.current_is_dir():
			result.append(str(path, "/", fileName))
		
		fileName = directory.get_next()
		
	return result
