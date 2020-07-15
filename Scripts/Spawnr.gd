extends Node2D

const nme1 = preload("res://Physical/Container.tscn")
const nme2 = preload("res://Physical/GContainer.tscn")
const nme3 = preload("res://Physical/PContainer.tscn")
var nmes = [nme1, nme2, nme3]
var R = RandomNumberGenerator.new()

func spawn(nme):
	var spwn = nme.instance()
	var screen_size = get_viewport().get_visible_rect().size
	R.randomize()
	var x = R.randf_range(0,screen_size.x)
	R.randomize()
	var y = R.randf_range(0,screen_size.y)
	spwn.position.y = y
	spwn.position.x = x
	spwn.might = R.randi_range(10, 100)
	add_child(spwn)

func _process(delta):
	if get_child_count() < 33:
		spawn(nmes[R.randi_range(0,2)])
