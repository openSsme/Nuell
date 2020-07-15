extends Node2D

var target
var speed = 800
var gun

func move():
	if target != null:
		look_at(target.position)
		var direction = target.position - self.position
		var motion = direction.normalized() * speed
		$".".move_and_slide(motion)
	else:
		queue_free()

func _on_Area2D_body_entered(body):
	if body != gun and body.might != 0:
		body.might -= 1
		queue_free()
		#print(body.might)
	if body != gun and body.might == 0:
		body.get_node("Sprite").play("die")
		queue_free()

func _process(delta):
	move()

