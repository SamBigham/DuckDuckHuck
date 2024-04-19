extends CharacterBody2D
@onready var  packed = PackedVector2Array()
@onready var path_follow = $".."
@onready var path = $"../.."
@onready var sprite = $Sprite2D
var speed = 100 
var floaty = 2
var vec = Vector2(0,0)
var offs = Vector2(0,0)
func _ready():
	for n in 10:
		packed.push_back(Vector2(n*10,n*10))
		path.curve.add_point(packed[n] - offs,vec, vec, n)
		
func _physics_process(delta):
	path_follow.progress += (speed * delta)
#	 * (1 - path_follow.get_progress_ratio()
#	 + (path_follow.get_progress_ratio() / floaty ) ) )
	
	queue_redraw()


func _draw():
#	draw_circle(Vector2(0,0), 200, Color.REBECCA_PURPLE)
	draw_multiline(packed, Color.ALICE_BLUE, 5)
