extends AnimatedSprite3D
var timer
var digging = false
var shovelShift = 0.2
signal digSignal(shovelPosition)

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if digging and !timer.is_stopped():
		return
	if Input.is_action_pressed("dig"):
		animation = "dig"
		digging = true
		timer.start()
		var shovelPosition = self.global_position
		if flip_h:
			shovelPosition.x -= shovelShift
			print("left")
		else:
			shovelPosition.x += shovelShift
			print("right")
		digSignal.emit(shovelPosition)
		return
	var velocity = Vector3.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.z += 1
	if Input.is_action_pressed("move_up"):
		velocity.z -= 1
	position += velocity * delta
	
	if velocity != Vector3.ZERO:
		animation = "walk"
		flip_v = false
		if velocity.x==0:
			return
		flip_h = velocity.x < 0

	if velocity == Vector3.ZERO:
		animation = "idle"


func _on_animation_finished():
	print("finished")


func _on_timer_timeout():
	digging = false
	animation = "idle"
