extends CharacterBody2D

@onready var mainchar = $"../DuckBody2D"
@onready var sprite = $Sprite2D
@onready var frisbee = $"../Path2D/PathFollow2D/FrisPath"
@onready var node = $".."
var pos = $".".position
var bezend
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready():
	pass
#	velocity.x = 300

func _physics_process(_delta):
	frisbee = $"../Path2D/PathFollow2D/FrisPath"
	if node.lastbezloc != null:
		bezend = node.lastbezloc()
	if bezend != null:
		if bezend.x > 0:
			velocity.x = sqrt(abs(bezend.x)) * 10
		else:
			velocity.x = sqrt(abs(bezend.x)) * -10
		if bezend.y > 0:
			velocity.y = sqrt(abs(bezend.y)) * 10
		else:
			velocity.y = sqrt(abs(bezend.y)) * -10


	move_and_slide()
	

func changedir():
	velocity.x = velocity.x * -1
