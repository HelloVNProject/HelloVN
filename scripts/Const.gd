extends Node

#type: 显示风格（picture: 大图显示，both: 图文并茂，article: 文章

# 额外内容 数据流 简版
var ExtrasData = [
	{
		"id": "mobs",
		"name": "TR:EXTRA:MOBS",
		"items": [
			{
				"id": "gr",
				"name": "TR:EXTRA:GR:NICKNAME",
			},
			{
				"id": "seaon",
				"name": "TR:EXTRA:SEAON:NICKNAME",
			},
			{
				"id": "can",
				"name": "TR:EXTRA:CAN:NICKNAME",
			},
			{
				"id": "romin",
				"name": "TR:EXTRA:ROMIN:NICKNAME",
			},
			{
				"id": "sam",
				"name": "TR:EXTRA:SAM:NICKNAME",
			},
			{
				"id": "nik",
				"name": "TR:EXTRA:NIK:NICKNAME",
			},
			{
				"id": "yao",
				"name": "TR:EXTRA:YAO:NICKNAME",
			},
			{
				"id": "todd",
				"name": "TR:EXTRA:TODD:NICKNAME",
			},
			{
				"id": "amorog",
				"name": "TR:EXTRA:AMOROG:NICKNAME",
			},
			{
				"id": "ten",
				"name": "TR:EXTRA:TEN:NICKNAME",
			},
			{
				"id": "zombie",
				"name": "TR:EXTRA:ZOMBIE:NICKNAME",
			},
			{
				"id": "skeleton",
				"name": "TR:EXTRA:SKELETON:NICKNAME",
			},
		]
	}, {
		"id": "cgs",
		"name": "TR:EXTRA:CGS",
		"items": [
			{
				"id": "first-fight",
				"name": "TR:EXTRA:FIRSTFIGHT:NAME",
			},
			{
				"id": "quick-time",
				"name": "TR:EXTRA:QUICKTIME:NAME",
			},
			{
				"id": "cave-invest",
				"name": "TR:EXTRA:CAVEINVEST:NAME",
			},
			{
				"id": "niks-hat",
				"name": "TR:EXTRA:NIKSHAT:NAME",
			},
		]
	}, {
		"id": "term",
		"name": "TR:EXTRA:TERMS",
		"items": [
			{
				"id": "singal",
				"name": "TR:EXTRA:SINGAL:NAME",
			}, {
				"id": "environmental",
				"name": "TR:EXTRA:ENVIRONMENTAL:NAME",
			}, {
				"id": "ano-singal",
				"name": "TR:EXTRA:ANOSINGAL:NAME",
			}, {
				"id": "digcraft",
				"name": "TR:EXTRA:DIGCRAFT:NAME",
			}, {
				"id": "the-smoke-room",
				"name": "TR:EXTRA:THESMOKEROOM:NAME",
			}, {
				"id": "qte-rb",
				"name": "TR:EXTRA:QTERB:NAME",
			},
		]
	}, {
		"id": "staffs",
		"name": "TR:EXTRA:STAFFS"
	}, {
		"id": "assets",
		"name": "TR:EXTRA:THIRD:TITLE"
	},
]

# 额外内容 数据量
var ExtrasDetailData = {
	"gr": {
		"render": "both",
		"name": "TR:EXTRA:GR:FULLNAME",
		"subname": "GR",
		"desc": "TR:EXTRA:GR:DESC",
		"pic": "res://images/sprites/gr/Default.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:GR:EXTRAS:1"
			}
		]
	},
	"seaon": {
		"render": "both",
		"name": "TR:EXTRA:SEAON:FULLNAME",
		"subname": "Seaon",
		"desc": "TR:EXTRA:SEAON:DESC",
		"pic": "res://images/sprites/seaon/Default.png",
	},
	"can": {
		"render": "both",
		"name": "TR:EXTRA:CAN:FULLNAME",
		"subname": "Dog Si. Can",
		"desc": "TR:EXTRA:CAN:DESC",
		"pic": "res://images/sprites/can/Default.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:CAN:EXTRAS:1"
			},
			{
				"chapter": 2.01,
				"content": "TR:EXTRA:CAN:EXTRAS:2"
			},
			{
				"chapter": 2.02,
				"content": "TR:EXTRA:CAN:EXTRAS:3"
			},
		]
	},
	"romin": {
		"render": "both",
		"name": "TR:EXTRA:ROMIN:FULLNAME",
		"subname": "Dog Gr. Romin",
		"desc": "TR:EXTRA:ROMIN:DESC",
		"pic": "res://images/sprites/romin/Default.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:ROMIN:EXTRAS:1"
			},
			{
				"chapter": 2.01,
				"content": "TR:EXTRA:ROMIN:EXTRAS:2"
			},
		]
	},
	"nik": {
		"render": "both",
		"name": "TR:EXTRA:NIK:FULLNAME",
		"subname": "Nikolai Krol",
		"desc": "TR:EXTRA:NIK:DESC",
		"pic": "res://images/sprites/nik/tsr/nik h.png",
		"extras": [
			{
				"chapter": 1.02,
				"content": "TR:EXTRA:NIK:EXTRAS:1"
			}
		]
	},
	"sam": {
		"render": "both",
		"name": "TR:EXTRA:SAM:FULLNAME",
		"subname": "Samuel Ayers",
		"desc": "TR:EXTRA:SAM:DESC",
		"pic": "res://images/sprites/sam/tsr/sam.png",
		"extras": [
			{
				"chapter": 2.01,
				"content": "TR:EXTRA:SAM:EXTRAS:1"
			}
		]
	},
	"yao": {
		"render": "both",
		"name": "TR:EXTRA:YAO:FULLNAME",
		"subname": "Feng Yaolin",
		"desc": "TR:EXTRA:YAO:DESC",
		"pic": "res://images/sprites/yao/tsr/yao.png",
		"extras": [
#			{
#				"chapter": 2.01,
#				"content": "TR:EXTRA:YAO:EXTRAS:1"
#			}
		]
	},
	"todd": {
		"render": "both",
		"name": "TR:EXTRA:TODD:FULLNAME",
		"subname": "Todd Bronson",
		"desc": "TR:EXTRA:TODD:DESC",
		"pic": "res://images/sprites/todd/tsr/tod.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:TODD:EXTRAS:1"
			}
		]
	},
	"amorog": {
		"render": "both",
		"name": "TR:EXTRA:AMOROG:FULLNAME",
		"subname": "Bear P. Amorog",
		"desc": "TR:EXTRA:AMOROG:DESC",
		"pic": "res://images/no-image.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:AMOROG:EXTRAS:1"
			}
		]
	},
	"ten": {
		"render": "both",
		"name": "TR:EXTRA:TEN:FULLNAME",
		"subname": "Bear B. Ten",
		"desc": "TR:EXTRA:TEN:DESC",
		"pic": "res://images/no-image.png",
		"extras": [
			{
				"chapter": 1.01,
				"content": "TR:EXTRA:TEN:EXTRAS:1"
			}
		]
	},
	"zombie": {
		"render": "both",
		"name": "TR:EXTRA:ZOMBIE:NICKNAME",
		"subname": "Zombie",
		"desc": "TR:EXTRA:ZOMBIE:DESC",
		"pic": "res://images/sprites/zombie/introduction.png",
	},
	"skeleton": {
		"render": "both",
		"name": "TR:EXTRA:SKELETON:NICKNAME",
		"subname": "Skeleton",
		"desc": "TR:EXTRA:SKELETON:DESC",
		"pic": "res://images/sprites/skeleton/introduction.png",
	},
	
	"first-fight": {
		"render": "both",
		"name": "TR:EXTRA:FIRSTFIGHT:NAME",
		"subname": "First Fight",
		"unlockChapter": 1.01,
		"desc": "TR:EXTRA:FIRSTFIGHT:CONTENT",
		"pic": "res://images/cgs/first-fight.webp"
	},
	
	"quick-time": {
		"render": "both",
		"name": "TR:EXTRA:QUICKTIME:NAME",
		"subname": "Quick Time Events",
		"unlockChapter": 1.02,
		"desc": "TR:EXTRA:QUICKTIME:CONTENT",
		"pic": "res://images/no-image.png"
	},
	
	"niks-hat": {
		"render": "both",
		"name": "TR:EXTRA:NIKSHAT:NAME",
		"subname": "Damaged Helmet",
		"unlockChapter": 1.02,
		"desc": "TR:EXTRA:NIKSHAT:CONTENT",
		"pic": "res://images/cgs/niks-hat.webp"
	},
	
	"cave-invest": {
		"render": "both",
		"name": "TR:EXTRA:CAVEINVEST:NAME",
		"subname": "Cave Investigating",
		"unlockChapter": 1.01,
		"desc": "TR:EXTRA:CAVEINVEST:CONTENT",
		"pic": "res://images/cgs/cave-investgating-full.webp"
	},
	
	"singal": {
		"render": "both",
		"name": "TR:EXTRA:SINGAL:NAME",
		"subname": "Singal Light",
		"desc": "TR:EXTRA:SINGAL:DESC",
		"pic": "res://images/no-image.png"
	},
	"environmental": {
		"render": "both",
		"name": "TR:EXTRA:ENVIRONMENTAL:NAME",
		"subname": "Environmental Detector",
		"desc": "TR:EXTRA:ENVIRONMENTAL:DESC",
		"pic": "res://images/no-image.png"
	},
	"ano-singal": {
		"render": "article",
		"name": "TR:EXTRA:ANOSINGAL:NAME",
		"desc": "TR:EXTRA:ANOSINGAL:DESC",
	},
	"digcraft": {
		"render": "article",
		"name": "TR:EXTRA:DIGCRAFT:NAME",
		"desc": "TR:EXTRA:DIGCRAFT:DESC",
		"pic": "res://images/no-image.png",
	},
	"the-smoke-room": {
		"render": "both",
		"name": "TR:EXTRA:THESMOKEROOM:NAME",
		"subname": "\"The Smoke Room\"",
		"desc": "TR:EXTRA:THESMOKEROOM:DESC",
		"pic": "res://images/tsr/cover.png",
	},
	"qte": {
		"render": "both",
		"name": "TR:EXTRA:QTE:NAME",
		"subname": "Quick Time Events",
		"desc": "TR:EXTRA:QTE:DESC",
		"pic": "res://images/no-image.png"
	},
	"qte-rb": {
		"render": "both",
		"name": "TR:EXTRA:QTERB:NAME",
		"subname": "Quick Time Events with Rhythm-Based",
		"desc": "TR:EXTRA:QTERB:DESC",
		"pic": "res://images/no-image.png"
	},
	
	"staffs": {
		"render": "article",
		"name": "TR:EXTRA:STAFFS",
		"cellTranslate": true,
		"descRaw": null # 需要在 getExtraData 函数里指定结果
	},
	
	"assets": {
		"render": "article",
		"name": "TR:EXTRA:THIRD:TITLE",
		"cellTranslate": true,
		"descRaw": null # 需要在 getExtraData 函数里指定结果
	},
}

var BelongsToasts = {
	"cg1": {
		"artists": ["Rominwolf"],
		"thanks": ["GRtheGreat"]
	},
	"cg2": {
		"artists": ["tiAnsxq"],
	},
	"cg3": {
		"artists": ["GRtheGreat"],
	},
	"cg4": {
		"artists": ["EJheptene"],
	},
	
	"bgm1": {
		"musicians": ["Linkmusicnow"],
	},
}

# 创作者跳转链接
var dictStaffsURLs = parseStaffsLink()

func bbcodeTableBuilder(data):
	var cols = data[0]
	var rows = data[1]
	
	var result = str("[table=", cols.size(), "]")
	
	for i in cols.size():
		var col = str(cols[i])
		
		var mixed = Global.parseTexts("[cell][b]{title}[/b][/cell]", {"title": col})
		result += mixed
		
	for i in rows.size():
		var row = str(rows[i])
			
		var mixed = Global.parseTexts("[cell]{text}[/cell]", {"text": row})
		result += mixed
		
	result += "[/table]"
	
	return result


# 解析创作者的用户名，如果在字典里匹配则添加链接，并且查看是否存在相对应语言的翻译
# 国内：国内平台，国际：推特等
func parsingStaffs(data):
	var rows = data[1]
	
	var locale = TranslationServer.get_locale()
	var lang = "intl"
	
	# 国内版特别
	if locale == "zh_CN":
		lang = "zh_CN"
	
	for i in rows.size():
		var row = rows[i]
		
		var itemsRaw = row
		var items = row.split(",")
		
		for ii in items.size():
			var item = str(items[ii]).strip_edges()
			var originItem = item
			
			item = tr(item)

			# 如果翻译了，则更新到上级字符串
			if item != originItem:
				itemsRaw = itemsRaw.replace(originItem, item)
			
			# 如果项目没有 @ 则表示不是创作者，直接跳过
			if !"@" in item:
				continue
				
			var staffName = str(Global.getBetweenString(item, "@", "")).lstrip("@").strip_edges()
			
			var url = null
			
			if !dictStaffsURLs[lang].has(staffName):
				if !dictStaffsURLs["intl"].has(staffName):
					# 如果全部维度都不存在此创作者的链接则跳过
					continue
				else:
					url = dictStaffsURLs["intl"][staffName]
			else:
				url = dictStaffsURLs[lang][staffName]
				
			var mixed = str("[url=", url, "]", item, "[/url]")
			
			itemsRaw = itemsRaw.replace(item, mixed)
			
		rows[i] = rows[i].replace(row, itemsRaw)
			
	data[1] = rows
	return data

# 解析所有语言的译者
func parsingTranslators():
	var dicts = Global.getValuesFromAllTranslations("TR:SYSTEM:TRANSLATOR")
	var result = ""
	
	for dict in dicts:
		var localeName = TranslationServer.get_locale_name(dict.locale)
		var text = dict.text
		
		if(text == ""):
			continue
			
		result += str("@", text, " (", localeName, "), ")
		
	result = str(result).rstrip(", ")
	return result

func getExtraData(asDetail = false):
	if asDetail:
		var result = ExtrasDetailData
		result.staffs.descRaw = bbcodeTableBuilder(
			parsingStaffs(
				parsingCsvFile("res://excels/staffs.csv")
			)
		)
		result.assets.descRaw = bbcodeTableBuilder(
			parsingCsvFile("res://excels/assets.csv", true)
		)
		
		return result
	
	return ExtrasData

# 解析 CSV 文件
# keepSpace: 是否保留空单元格
# useArrayForData: 第二行内使用数组
func parsingCsvFile(filePath, keepSpace = false, useArrayForData = false):
	var result = [[], []]
	
	var file = File.new()
	var error = file.open(filePath, File.READ)
	
	if error != OK:
		print(error)
		return result
	
	var i = 0
	while !file.eof_reached():
		var data = file.get_csv_line()
		
		# 如果为第二行及以后且使用数组嵌套：
		if i > 0 and useArrayForData:
			result[1].append(data)
			continue
		
		for oneData in data:
			# 空白内容，如果不保留则直接跳过
			if !keepSpace and oneData == "":
				continue
			
			if i == 0:
				result[0].append(oneData)
			else:
				result[1].append(oneData)
		
		i += 1
	
	file.close()
	return result

# 解析 Staffs Link
func parseStaffsLink():
	var result = {
		"zh_CN": {},
		"intl": {}
	}
	
	# 解析 Staffs Links 的第二行开始的数据
	var parsedData = parsingCsvFile("res://excels/links.csv", true, true)[1]
	
	# 循环遍历每行
	for row in parsedData:
		# 行长度小于 3 则跳过
		if row.size() < 3:
			continue
		
		var staffName = row[0]
		var zhCnLink = row[1]
		var intlLink = row[2]
		
		if zhCnLink != "":
			result.zh_CN[staffName] = zhCnLink
			
		if intlLink != "":
			result.intl[staffName] = intlLink
			
	return result
