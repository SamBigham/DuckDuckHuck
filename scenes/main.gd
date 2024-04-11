extends Node2D

@onready var packed = $Path2D.curve.get_baked_points()
@onready var path = $Path2D
@onready var spriteloc = $DuckBody2D  #location bezier curve starts from
@onready var savepoint = $savepoint
@onready var timlab = $timelabel
@onready var mathsaver = $mathsaver
@onready var lastclick = Array()
@onready var  beziervec
@onready var  bezierpack = PackedVector2Array()
@onready var  bezierpack2 = PackedVector2Array() #used for recursion
@onready var  bezierpack3 = PackedVector2Array() #where final bezier curve points are stored
@onready var frisbeetrail = $Path2D/PathFollow2D/FrisPath
@onready var  beztrail
@export var slower = 0.01 # used for bezier curve to make t value smaller
@export var an = 1 #angle of points when creating on curve
var p = 0 #used for recursion on bezier
var inDuck = false

var c = Color.RED #color of line
var linelength = 10

const offs = Vector2(0,0) #adds to  where object leaves from
const spriteoffs = Vector2(27,25) #changes where everything starts


# Called when the node enters the scene tree for the first time.
func _ready():
	vectorreset()
	
	
func _process(_delta):
#	print(get_canvas_item())
#	print(path.get_canvas_item())
	timlab.text = "%s" % savepoint.time_left #to display timeleft on the timer savepoint
	
	#starts frisbee path calculations
	if(Input.is_action_just_pressed("click") and spriteloc.hasDisc):
		savepoint.start() #limit for time to throw frisbee
		mathsaver.start() #plays at a faster interval than savepoint
		clearDrawing() 
	if(Input.is_action_just_released("click") and (savepoint.time_left != 0)):
		savepoint.stop() #either savepoint times out or click is released
		calc()
		
	#if character is moving, then the drawing is erased
	if ((spriteloc.velocity.x != 0 or spriteloc.velocity.y != 0) and !spriteloc.hasDisc):
		bezierpack3.clear()
		queue_redraw()
		
#		packed = $Path2D.curve.get_baked_points()
		
		
	
func clearDrawing():
	path.curve.clear_points()
	packed = $Path2D.curve.get_baked_points()
	lastclick.clear()
	queue_redraw()
	
# this is a good place to put stuff that should be calculated when the curve is created and the
# disc is moving
func updateDrawing():
	inDuck = true
	frisbeetrail.visible = true
	spriteloc.disc_invisible()
	path.curve.clear_points()
	timeoutcall()
	
func _draw():
#	if packed.size() >= 2:
#		draw_polyline(packed, c,linelength, false)
	if(bezierpack3.size() != 0 and (bezierpack3.size() % 2) == 0):
		draw_multiline(bezierpack3,Color.AQUAMARINE,linelength)
	else: if ((bezierpack3.size() != 0) and bezierpack3.size() % 2 == 1):
		bezierpack3.insert(0, bezierpack3[0])
		draw_multiline(bezierpack3,Color.AQUAMARINE,linelength)


func timeoutcall():
	var mosloc = get_local_mouse_position()
	var globloc = spriteloc.global_position + spriteoffs
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
	packed = $Path2D.curve.get_baked_points()
	for n in packed.size():
		packed[n] = packed[n] + offs

func _on_arctim_timeout():
	timeoutcall()


func save_click() :
	lastclick.push_back(get_local_mouse_position())
	

func vectorreset():
	bezierpack =  PackedVector2Array()
	for j in path.curve.get_point_count():
		bezierpack.append(path.curve.get_point_position(j))
	bezierpack2 = PackedVector2Array(bezierpack)
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
	if (p > 1):
		vectorreset()
		p = 0
	else:
		p += slower
	beziervec = bezier_help(k,p)
	
func calc():
	if lastclick.size() != 0:
		updateDrawing()
		vectorreset()
		for n in 100:
			incbez(path.curve.get_point_count())
			bezierpack3.push_back(beziervec + offs)
		path.curve.clear_points()#path.curve is how we move
		for n in bezierpack3.size():
			path.curve.add_point(bezierpack3[n] - offs,Vector2(-an,an), Vector2(an,-an), n)
		queue_redraw()

func _on_mathsaver_timeout():
	if (!savepoint.is_stopped()):
		save_click()
		mathsaver.start()

func _on_savepoint_timeout():
	calc()



func _on_fris_path_body_entered(body):
	if (body.is_in_group("characters") and !inDuck):
		print("catch")
		frisbeetrail.visible = false
		frisbeetrail.position = Vector2(0,0)
		hold_frisbee()
		
func hold_frisbee():
	vectorreset()
	queue_redraw()
	spriteloc.disc_visible()
	inDuck = true

	

# Will use as a toggle to prevent the disc from being caught immediately
# May have issues with rotating and collision if collision object also rotates
func _on_fris_path_body_exited(body):
	if (body.is_in_group("characters")):
		inDuck = false
