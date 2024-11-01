extends MeshInstance3D
var textLabel
var isWin = false
var porriges = []
var porrigeDelta = 0.024
var porrigeHeight = 0.06

func _ready():
	textLabel = $textLabel

func _set_text(text):
	textLabel.text = text

func _init_porrige(count):
	var load_porrige = load("res://porrige/porrige.tscn")
	for i in range(count):
		var porrige = load_porrige.instantiate()
		self.add_child(porrige)
		porrige.global_position.y = porrigeDelta + i * porrigeHeight
		porriges.append(porrige)
		
func _add_porrige(porrige):
	porriges.append(porrige)
	
func _create_porrige():
	var load_porrige = load("res://porrige/porrige.tscn")
	var porrige = load_porrige.instantiate()
	self.add_child(porrige)
	porrige.global_position.y = porrigeDelta + porriges.size() * porrigeHeight
	porriges.append(porrige)

func _check_win():
	if isWin and porriges.size() == 0:
		return true
	return false

func _movePorrige(to):
	var porrige = porriges.pop_back()	
	if porrige == null:
		print("no porrige left")
		return
	var newPlace = to.global_position
	newPlace.y = porrigeDelta + to.porriges.size() * porrigeHeight
	to._add_porrige(porrige)
	porrige._move(newPlace)
	return porrige
