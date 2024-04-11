extends CharacterBody2D

@onready var Duck = $Sprite2D
@onready var fris = $Sprite2D2
@onready var wing = $Sprite2D2/Sprite2D3
@onready var backfris = $backward
@onready var backwing = $backward/otherbackwards

const SPEED = 600.0
const UP_SPEED = -400.0
var hasDisc = 0
var originalpos
var BIGNUMBER = Vector2(-1000, -1000)

func _ready():
	originalpos = fris.position
	
func _physics_process(delta):
		
	var direction = Input.get_axis("left", "right")
	if !fris.is_visible_in_tree():
		hasDisc = 0
		
		#rotates duck back to a rotation of 0
		if Duck.global_rotation_degrees > 20:
			Duck.rotate(-40 * delta)
			fris.rotate(-40 * delta)
			backfris.rotate(-40 * delta)
		else: if Duck.global_rotation_degrees < -20:
			Duck.rotate(40 * delta)
			fris.rotate(40 * delta)
			backfris.rotate(40 * delta)
		else:
			Duck.rotation = 0
			fris.rotation = 0
			backfris.rotation = 0
			
			
		if velocity.x > 1 || velocity.x < -1 :
			Duck.animation = "running"
			if velocity.x > 1:
				Duck.flip_h = false
			else: if velocity.x < -1:
				Duck.flip_h = true
		else:
			Duck.animation = "idle"
		if Input.is_action_pressed("up"):
			velocity.y = UP_SPEED * 1.5 + 0 *delta
		else: if Input.is_action_pressed("down"):
			velocity.y = UP_SPEED * -1.5
		else : 
			velocity.y = 0
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		hasDisc = 1
		Duck.animation = "idle"
		velocity.x = 0
		velocity.y = 0
		Duck.rotate(direction / 10)
		
		fris.rotate(direction / 10)
		backfris.rotate(direction / 10)
		
		

		if Input.is_action_just_pressed("up") and !Duck.flip_h:
			if originalpos:
				fris.position = originalpos
			Duck.flip_h = true
			backfris.visible = true
			originalpos = fris.position
			fris.position = BIGNUMBER
			
#			fris.apply_scale(Vector2(-1,1))

		if Input.is_action_just_pressed("down") and Duck.flip_h:
			Duck.flip_h = false
			backfris.visible = false
			if originalpos:
				fris.position = originalpos
			print(originalpos)
			
#		wing.rotate(direction / 100)
	move_and_slide()


func disc_visible():
	if Duck.flip_h:
		backfris.visible = true
		
		fris.position = BIGNUMBER
		fris.visible = true
	else: 
		if originalpos:
			fris.position = originalpos
		fris.visible = true
	
func disc_invisible():
	fris.visible = false
	backfris.visible = false
