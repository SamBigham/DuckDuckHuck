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
const SPEED = 20000.0
const JUMP_VELOCITY = -400.0
var hasDisc = 0
var smallvec = Vector2(10,10)
var vecspeed = Vector2(100,0)
var stackpos = Vector2(800, 400)
var stacksetter = false


func _ready():
	var groups = get_groups()
	if groups.size() >=2:
		if  groups[1] == "stacksetter":
			stacksetter = true
			
#	velocity.x = 300

func _physics_process(delta):
	
	if node.lastbezloc() != null:
		bezend = node.lastbezloc()
		
	if (bezend and frisbee.moving) and !myspriteanimdisc.visible:
#		var mousepos = bezend
		var direction = (bezend - position).normalized()
		
		#stacksetter won't move towards frisbee when it's thrown
		if stacksetter:
			direction = Vector2(0,0)

		velocity = direction * SPEED *delta
		if (sprite.position > bezend - smallvec and sprite.position < bezend + smallvec):
			velocity = Vector2(0,0)
	else: if (!myspriteanimdisc.visible):
		#if the character is a stacksetter it will move towards the stack position
		if stacksetter:
			#prevents the character for spassing out
			if (sprite.position > stackpos - smallvec and sprite.position < stackpos + smallvec):
				velocity = Vector2(0,0)
			else:
				velocity =(stackpos - position).normalized() * SPEED * delta

		else:
			
			velocity.x = vecspeed.x
			velocity.y = 0
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
	vecspeed = vecspeed * -1

func disc_visible():
	hasDisc = 1
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
	hasDisc = 0
	myspriteanimdisc.visible = false
	myspriteanim.visible = true
	
	if myspriteanimdisc.flip_h:
		myspriteanim.flip_h = true
	else:
		myspriteanim.flip_h = false

#throws the frisbee
func throw():
	pass
