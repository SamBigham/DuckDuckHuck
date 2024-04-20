extends Node2D

@onready var packed = $Path2D.curve.get_baked_points()
@onready var path = $Path2D
@onready var char1 = $char
@onready var spriteloc = $DuckBody2D  #location bezier curve starts from
@onready var savepoint = $savepoint
@onready var timlab = $timelabel
@onready var FPS = $FPS
@onready var mathsaver = $mathsaver
@onready var lastclick = Array()
@onready var  beziervec
@onready var  bezierpack = PackedVector2Array()
@onready var  bezierpack2 = PackedVector2Array() #used for recursion
@onready var  bezierpack3 = PackedVector2Array() #where final bezier curve points are stored
@onready var frisbeetrail = $Path2D/PathFollow2D/FrisPath
@onready var pathfollow  = $Path2D/PathFollow2D
@onready var chartimer = $chartimeout
@onready var delay = $delay
@onready var  beztrail

#slower could be causing trail to get less and less each time
@export var slower = 0.01 # used for bezier curve to make t value smaller
@export var an = 1 #angle of points when creating on curve
var originalpacked 
var p = 0 #used for recursion on bezier
var inDuck = false
var inBody = false
var caught = false
var wait = false
var BodyWithDisc

var c = Color.RED #color of line
var linelength = 10

const offs = Vector2(0,0) #adds to  where object leaves from
const spriteoffs = Vector2(0,0) #changes where everything starts


# Called when the node enters the scene tree for the first time.
func _ready():
	originalpacked = packed
	BodyWithDisc = spriteloc
	vectorreset()
	
	
func _process(_delta):
#	print(get_canvas_item())
#	print(path.get_canvas_item())
	timlab.text = "%s" % savepoint.time_left #to display timeleft on the timer savepoint
	FPS.text ="%s" % Engine.get_frames_per_second()
	
	#starts frisbee path calculations
	if(Input.is_action_just_pressed("click") and BodyWithDisc.hasDisc):
		savepoint.start() #limit for time to throw frisbee
		mathsaver.start() #plays at a faster interval than savepoint
		clearDrawing() 
	if(Input.is_action_just_released("click") and (savepoint.time_left != 0)):
		savepoint.stop() #either savepoint times out or click is released
		calc(BodyWithDisc)

	#if character is moving, then the drawing is erased
	if ((spriteloc.velocity.x != 0 or spriteloc.velocity.y != 0) and !spriteloc.hasDisc):
		bezierpack3.clear()
		queue_redraw()
		
#		packed = $Path2D.curve.get_baked_points()
#	if lastbezloc():
#		print(lastbezloc())
		
	
func clearDrawing():
	path.curve.clear_points()
	packed = originalpacked
	lastclick.clear()
	queue_redraw()
	
# this is a good place to put stuff that should be calculated when the curve is created and the
# disc is moving
func updateDrawing(bdy):
	
	#could be bugs related to this code... needs to be tested when two bodies are nearby
	inDuck = true
	inBody = true
	bdy.disc_invisible()
#	path.curve.clear_points()
	timeoutcall(bdy)
#	frisbeetrail.visible = true
	frisbeetrail.visible = true
	
func _draw():
#	if packed.size() >= 2:
#		draw_polyline(packed, c,linelength, false)
	if(bezierpack3.size() != 0 and (bezierpack3.size() % 2) == 0):
		draw_multiline(bezierpack3,Color.AQUAMARINE,linelength)
	else: if ((bezierpack3.size() != 0) and bezierpack3.size() % 2 == 1):
		bezierpack3.insert(0, bezierpack3[0])
		draw_multiline(bezierpack3,Color.AQUAMARINE,linelength)


func timeoutcall(bdy):
	
	var mosloc = get_global_mouse_position()
	#globloc controls where the frisbee starts
	var globloc = bdy.global_position + spriteoffs
	path.curve.add_point(globloc - offs, Vector2(an,an), Vector2(an,-an), 0)

	if((globloc.y - mosloc.y >= 0) && globloc.x - mosloc.x <= 0) :
		c = Color.ANTIQUE_WHITE
	else: if ((globloc.y - mosloc.y > 0) && globloc.x - mosloc.x > 0):
		c = Color.GREEN
	else: if ((globloc.y - mosloc.y < 0) && globloc.x - mosloc.x >= 0):
		c = Color.RED
	else:
		c = Color.BLUE_VIOLET

	if (lastclick.size() != 1):
		for n in lastclick.size():
			path.curve.add_point(lastclick[n] - offs, Vector2(-an,an), Vector2(an,-an), n + 1)
#	packed = path.curve.get_baked_points()
#	for n in packed.size():
#		packed[n] = packed[n] + offs
	




func save_click() :
	lastclick.push_back(get_global_mouse_position())
	

func vectorreset():
	bezierpack =  PackedVector2Array()
	for j in path.curve.get_point_count():
		bezierpack.append(path.curve.get_point_position(j))
	bezierpack2 = PackedVector2Array()
	bezierpack3 = PackedVector2Array()
func bezier_help(i,t):
	if (bezierpack.size() <= 2):
		return Vector2(0,0)
	if (i <= 1):
		return (bezierpack[0].lerp(bezierpack[1], t * slower * 10))
	else:
		for k in (i -1):
			bezierpack[k] = bezierpack[k].lerp(bezierpack[k + 1],t * slower * 10) 
		return bezier_help((i -1),t)
		
func incbez(k):
	#p represents the progress along the bezier curve
	
	if (p > 1):
		vectorreset()
		p = 0 + slower
	else:
		
		p += 0.01
	print(p)
	beziervec = bezier_help(k,p)
	
func calc(bdy):
	if lastclick.size() <= 1:
		lastclick.push_back(bdy.global_position)
		lastclick.push_back(get_global_mouse_position())
#	if lastclick.size() != 0:
		
	#update drawing could be causing breif flashes of characters at the begginning
	updateDrawing(bdy)
	vectorreset()
	for n in 100:
#		print(n)
		incbez(path.curve.get_point_count())
		bezierpack3.push_back(beziervec + offs)
	path.curve.clear_points()#path.curve is how we move
	for n in bezierpack3.size():
		path.curve.add_point(bezierpack3[n] - offs,Vector2(-an,an), Vector2(an,-an), n)
	
	queue_redraw()
	wait = true
	delay.start()
#	print(bdy.get_groups())

func _on_mathsaver_timeout():
	if (!savepoint.is_stopped()):
		save_click()
		mathsaver.start()

func _on_savepoint_timeout():
	calc(BodyWithDisc)



func _on_fris_path_body_entered(body):
#	print("caught: ", caught)
#	print("inDuck: ", inDuck)

	
	if !frisbeetrail.visible:
		caught = true
	else:
		caught = false
#	print("wait ", wait)

	if ((body.is_in_group("characters") and !body.is_in_group("maincharacter"))and !wait and !inDuck and !caught):
		print("sidecharacter")
		
		frisbeetrail.visible = false
		BodyWithDisc = body
		caught = false
		wait = true
		delay.start()
		frisbeetrail.position = Vector2(0,0)
		char_hold_frisbee(body)
		
		chartimer.start()
		save_click()
		mathsaver.start()
		
	if ((body.is_in_group("characters") and body.is_in_group("maincharacter")) and !inDuck and !wait and !caught):
		print("catch")
		
		frisbeetrail.visible = false
		caught = false
		wait = true
		delay.start()
		BodyWithDisc = body
		frisbeetrail.position = Vector2(0,0)
		hold_frisbee()
		
func hold_frisbee():
	vectorreset()
	queue_redraw()
	BodyWithDisc.disc_visible()
	inDuck = true
	
func char_hold_frisbee(bdy):
	vectorreset()
	queue_redraw()
	bdy.disc_visible()
	inBody = true
	
func lastbezloc():
	if bezierpack3.size() > 1:
		return bezierpack3[bezierpack3.size() -1]
	else:
		return null
# Will use as a toggle to prevent the disc from being caught immediately
# May have issues with rotating and collision if collision object also rotates
func _on_fris_path_body_exited(body):
	
	if (body.is_in_group("characters") and body.is_in_group("maincharacter")):
		inDuck = false
		inDuck = false
	else: if(body.is_in_group("characters")):
		inBody = false
		inDuck = false

func _on_border_body_entered(body):
	if body.is_in_group("characters") and !body.is_in_group("maincharacter"):
		body.changedir()
		


func _on_chartimeout_timeout():
	savepoint.stop()

	clearDrawing()
	var thrower = BodyWithDisc.position
	var target = spriteloc.global_position + offs
#	var middleground = (target - thrower)

	#flick
	var ground = thrower.project(target)
	
	#backhand
#	var ground = target.project(thrower)
	
	lastclick.push_back(thrower)
	lastclick.push_back(ground)
	lastclick.push_back(target)
	
	
	

	
	calc(BodyWithDisc)	
	pathfollow.progress = 0


func _on_delay_timeout():
	wait = false
