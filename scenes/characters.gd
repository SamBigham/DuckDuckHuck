extends CharacterBody2D

@onready var mainchar = $"../DuckBody2D"
@onready var sprite = $Sprite2D
@onready var frisbee = $"../Path2D/PathFollow2D/FrisPath"
@onready var node = $".."
var pos = $".".position
var spritenorm
var bezend
const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _ready():
	pass
#	velocity.x = 300

func _physics_process(_delta):
#	frisbee = $"../Path2D/PathFollow2D/FrisPath"
#	if node.lastbezloc != null:
#		bezend = node.lastbezloc()
#	if bezend != null:
#		bezend = bezend.normalized()
#		spritenorm = sprite.position.normalized()
#		pass
#		velocity.x = sprite.position.x - bezend.x
#		velocity.y = sprite.position.y - bezend.y
#		if bezend.x > 0:
#			velocity.x = sqrt(abs(bezend.x)) * 10
#		else:
#			velocity.x = sqrt(abs(bezend.x)) * -10
#		if bezend.y > 0:
#			velocity.y = sqrt(abs(bezend.y)) * 10
#		else:
#			velocity.y = sqrt(abs(bezend.y)) * -10
#
#	print("beznorm: ", bezend)
#	print("spritenorm: ", spritenorm)
#	if spritenorm and bezend:
#		var mov = spritenorm.distance_to(bezend)
#		print("subtraction: ", mov)
#		velocity = bezend * 500
	if node.lastbezloc != null:
		bezend = node.lastbezloc()
	if bezend:
		var mousepos = bezend
		var direction = (mousepos - position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	else:
		velocity = Vector2(0,0)
	

func changedir():
	pass
#	velocity.x = velocity.x * -1
#	velocity.y = velocity.y * -1
