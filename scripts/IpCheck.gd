extends Control

const url = "https://ip.useragentinfo.com/json"
var http: HTTPRequest

func getCurrentAddress():
	http = HTTPRequest.new()
	add_child(http)
	
	var error = http.request(url)
	
	if error != OK:
		closeHTTP()
		return {"code": 0}
		
	var response = yield(http, "request_completed")
	var body = response[3]
	
	closeHTTP()
	
	return parse_json(body.get_string_from_utf8())



func closeHTTP():
	remove_child(http)
	pass
