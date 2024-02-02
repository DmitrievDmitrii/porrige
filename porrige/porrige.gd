extends MeshInstance3D
var newPosition
var oldPosition
var distance = 0
var moving = false
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	newPosition = self.global_position
	timer =$Timer
	

func _move(_position):
	timer.start()
	moving = true
	newPosition = _position
	oldPosition = self.global_position
	distance = get_horizontal_distance(self.global_position, _position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !moving or !timer.is_stopped():
		return	
	var currentDistance = get_horizontal_distance(self.global_position, newPosition)	
	var toMove = newPosition
	toMove.y = newPosition.y - 9*(currentDistance)*(currentDistance-distance)
	self.global_position = self.global_position.move_toward(toMove, delta*2)
	if currentDistance < 0.001:
		moving = false

func get_horizontal_distance(pos1, pos2):
	return sqrt((pos1.x - pos2.x)**2 + (pos1.z - pos2.z)**2)


func _on_timer_timeout():
	pass
