extends Node3D
var floors=[]
var floorSize = 0.4
var _size = 10
var winIndexes
var winLabel

func _ready():
	winLabel = $gui/winLabel
	winLabel.visible = false
	winIndexes = get_random_indexes()
	var load_floor = load("res://square/floor.tscn")
	for i in range(_size):
		floors.append([])
		for j in range(_size):
			var floor = load_floor.instantiate()
			self.add_child(floor)
			floor.global_position.x = j * floorSize
			floor.global_position.z = i * floorSize
			floors[i].append(floor)
			floor._set_text(get_temp([i,j]))
			floor._init_porrige(1)
	
	floors[winIndexes[0]][winIndexes[1]].isWin = true
	print($character.global_position)
	print($Marker3D.global_position)

func get_floor_indexes(objectPosition):
	var i = floor((objectPosition.z + (floorSize / 2)) / 0.4)
	var j = floor((objectPosition.x + (floorSize / 2)) / 0.4)

	return [i,j]

func _on_character_dig_signal(shovelPosition):
	var showelIndexes = get_floor_indexes(shovelPosition)
	var showelFloor = floors[showelIndexes[0]][showelIndexes[1]]
	var randomFloor = get_suitable_random_floor(showelIndexes)
	var randomind = get_floor_indexes(randomFloor.global_position)
	print("showelIndexes", showelIndexes)
	print("randomind", randomind)
	showelFloor._movePorrige(randomFloor)
	if showelFloor._check_win():
		on_win()
	

func get_suitable_random_floor(indexes):
	var possibleFloors = []
	var playerIndexes = get_floor_indexes($character.global_position)
	for i in [indexes[0] - 1, indexes[0], indexes[0] + 1]:
		for j in [indexes[1] - 1, indexes[1], indexes[1] + 1]:
			if i < 0 or j < 0 or i >_size-1 or j>_size-1 or (i==playerIndexes[0] and j==playerIndexes[1]) or (i==indexes[0] and j==indexes[1]):
				continue
			possibleFloors.append(floors[i][j])
	var randomFloor = possibleFloors.pick_random()
	possibleFloors.clear()
	return randomFloor
	
func get_random_indexes():
	return [randi() % _size , randi() %_size]
	
func get_temp(indexes):
	var length = sqrt((winIndexes[0]-indexes[0])**2 + (winIndexes[1]-indexes[1])**2)
	if length < 1:
		return "win"
	if length < 2:
		return "very hot"
	if length < 4:
		return "hot"
	if length < 6:
		return "warm"
	if length < 8:
		return "cold"
	if length < 10:
		return "very cold"
	return "ffffff"

func on_win():
	winLabel.visible = true

func _on_add_timer_timeout():
	var randIndexes = get_random_indexes()
	floors[randIndexes[0]][randIndexes[1]]._create_porrige()
