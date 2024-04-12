extends CharacterBody2D

@onready var mainchar = $"../DuckBody2D"
@onready var frisbee = $"../Path2D/PathFollow2D/FrisPath"
@onready var sprite = $"."
@onready var node = $".."
@onready var myspriteanim = $AnimatedSprite2D
@onready var myspriteanimdisc = $AnimatedSprite2D2
var pos = $".".position
var spritenorm
var bezend
const SPEED = 15000.0
const JUMP_VELOCITY = -400.0



func _ready():
	pass
#	velocity.x = 300

func _physics_process(delta):
	
	if node.lastbezloc() != null:
		bezend = node.lastbezloc()
		
	if (bezend and frisbee.moving) and !myspriteanimdisc.visible:
#		var mousepos = bezend
		var direction = (bezend - position).normalized()
		
		velocity = direction * SPEED *delta
		if (sprite.position > bezend - Vector2(10,10) and sprite.position < bezend + Vector2(10,10)):
			velocity = Vector2(0,0)
		
	else:
		velocity = velocity / 1.3
#		velocity = Vector2(0,0)

		
	if velocity.x > 1 || velocity.x < -1 :
		myspriteanim.animation = "running"
	if velocity.x > 1:
		myspriteanim.flip_h = false
	else: if velocity.x < -1:
			myspriteanim.flip_h = true
	else:
		myspriteanim.animation = "default"
			
	move_and_slide()

func changedir():
	pass
#	velocity.x = velocity.x * -1
#	velocity.y = velocity.y * -1

func disc_visible():
	if myspriteanim.flip_h:

		myspriteanimdisc.visible = true
		myspriteanim.visible = false
		myspriteanimdisc.flip_h = true
	else: 
		myspriteanimdisc.flip_h = false
#		if originalpos:
#			fris.position = originalpos
		myspriteanimdisc.visible = true
		myspriteanim.visible = false
	
func disc_invisible():
	myspriteanimdisc.visible = false
	myspriteanim.visible = true
	
	if myspriteanimdisc.flip_h:
		myspriteanim.flip_h = true
	else:
		myspriteanim.flip_h = false

#throws the frisbee
func throw():
	pass
