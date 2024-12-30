extends Node

const SAVEFILE = "user://SAVEFILE.save"

var max_score = 0 
func _ready():
	load_score()
	
func save_score():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE_READ)
	file.store_32(max_score)
	file = null

func load_score():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		max_score = file.get_32()
