extends Area2D

#@onready var path_follow = $".."

@export var _speed = 1000
@onready var move = false
@onready var path = $"../.."
@export var floaty = 2
var l = 0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if move:

		var path_follow = $".."

		path_follow.progress += (_speed * delta * (1 - path_follow.get_progress_ratio()
		 + (path_follow.get_progress_ratio() / floaty ) ) )

func _on_savepoint_timeout():
	move = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		move = true

