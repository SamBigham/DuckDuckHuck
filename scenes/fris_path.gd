extends Area2D

#@onready var path_follow = $".."

@export var _speed = 1000
#@onready var move = false
@onready var path = $"../.."
@onready var frisbee = $Sprite2D
@export var floaty = 2

var l = 0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var path_follow = $".."

	path_follow.progress += (_speed * delta * (1 - path_follow.get_progress_ratio()
	 + (path_follow.get_progress_ratio() / floaty ) ) )
	#when frisbee completes path move is set back to false
	if path_follow.get_progress_ratio() == 1 or path_follow.get_progress_ratio() == 0:
		frisbee.animation = "default"
	else:
		frisbee.animation = "forward"

func _on_savepoint_timeout():
	pass

func _input(event: InputEvent) -> void:
	pass
#	if event.is_action_released("click"):
#		move = true

