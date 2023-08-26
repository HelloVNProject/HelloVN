extends Control


## The timeline to load when starting the scene
export(String, "TimelineDropdown") var timeline: String
export(bool) var add_canvas = true
export(bool) var reset_saves = true

func _ready():
	if reset_saves:
		Dialogic.reset_saves()
		
	var d
	
	print(Dialogic.get_slot_names())
		
	Dialogic.import({"definitions":{"glossary":[], "variables":[{"id":"1685872808-648", "name":"IsChapter1Finished", "type":0, "value":false}]}, "dialog_state":{"background":"res://images/tsr/minemazetunnel.webp", "background_music":null, "event_idx":11, "portraits":[{"character":"character-1685191246.json", "mirrored":false, "portrait":"shocked", "position":{0:false, 1:false, 2:false, 3:false, 4:true}, "z_index":0}, {"character":"character-1685190830.json", "mirrored":false, "portrait":"shocked crossed hat", "position":{0:false, 1:true, 2:false, 3:false, 4:false}, "z_index":0}, {"character":"character-1683993968.json", "mirrored":false, "portrait":"Shocked TSR", "position":{0:false, 1:false, 2:true, 3:false, 4:false}, "z_index":0}], "timeline":"timeline-1683991002.json"}, "state":{}})
	d = Dialogic.start('')
	
	if Dialogic.load():
		d = Dialogic.start('')
	else:	
		d = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn", add_canvas)
	
	get_parent().call_deferred('add_child', d)
	_copy_signals(d if not add_canvas else d.dialog_node)	
	queue_free()

func _copy_signals(dialogic:Node):
	var sigs = self.get_signal_list()
	for s in sigs:
		if not s['name'] in _signals_to_copy:
			continue
		if not dialogic.has_signal(s['name']):
			print("Cannot copy connections of signal " + s['name'] + " from " + self.to_string() + " to " + dialogic.to_string())
			continue
		var conns = self.get_signal_connection_list(s['name'])
		for c in conns:
			dialogic.connect(c['signal'], c['target'], c['method'], c['binds'], c['flags'])


var _signals_to_copy = [
	'event_start',
	'event_end',
	'text_complete',
	'timeline_start',
	'timeline_end',
	'dialogic_signal',
	'letter_displayed',
]
## -----------------------------------------------------------------------------
## 						SIGNALS (proxy copy of DialogNode signals)
## -----------------------------------------------------------------------------
# Event end/start
signal event_start(type, event)
signal event_end(type)
# Text Signals
signal text_complete(text_data)
# Timeline end/start
signal timeline_start(timeline_name)
signal timeline_end(timeline_name)
# Custom user signal
signal dialogic_signal(event)
signal letter_displayed(lastLetter)


