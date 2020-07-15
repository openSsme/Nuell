extends Node2D

export (int) var speed = 60
export (bool) var can_move = true
var security = 0
var threat = 0
var ucorn = hash($".")
var R = RandomNumberGenerator.new()
var might = R.randi_range(10, 100)
onready var label = $Label
var synkd = false
const bullet = preload("res://Physical/Bullet.tscn")

func move():
	label.text = str(might)
	
	if $Radar.is_colliding() and $Radar.get_collider() != null and might != 0:
		if $Radar.get_collider().is_in_group(str($".")+".threat") and $Radar.get_collider().might != 0:
			var target = $Radar.get_collider()
			var direction
			var motion
			var blt = bullet.instance()
			blt.name = str($".")+"Bullet"
			blt.gun = $"."
			blt.target = target
			blt.global_position = global_position
			
			if !$"../".has_node(blt.name) and target.might != 0:
				$"../".add_child(blt)
			
			if security >= threat and might > target.might or security <= threat and might > target.might:
				direction = target.position - self.position
				motion = direction.normalized() * speed
				if !target.is_in_group(str($".")+".nearby"):
					$".".move_and_slide(motion)
					$Sprite.play("run")
			elif security < threat and might < target.might or target.is_in_group(str($".")+".nearby"):
				direction = self.position - target.position
				motion = direction.normalized() * speed
				if !target.is_in_group(str($".")+".nearby"):
					$Sprite.play("run")
					$".".move_and_slide(motion)
			else:
				$Radar.rotate(1)
				$Sprite.play("idle")
		else:
			$Radar.rotate(1)
			$Sprite.play("idle")
	else:
		if might == 0:
			$Radar.enabled = false
		else:
			$Radar.rotate(1)
			$Sprite.play("idle")

func _on_Sprite_animation_finished():
	if might == 0:
		$CollisionShape2D.queue_free()
		$Label.visible = false
		#queue_free()


func _on_Ears_body_entered(body):
	if body.get_node("Color").text == $Color.text:
		body.add_to_group(str($".")+".security")
		security += 1
	else:
		body.add_to_group(str($".")+".threat")
		threat += 1

func _on_Ears_body_exited(body):
	if body.is_in_group(str($".")+".security"):
		body.remove_from_group(str($".")+".security")
		security -= 1
	else:
		body.remove_from_group(str($".")+".threat")
		threat -= 1

func _on_Proximity_body_entered(body):
	body.add_to_group(str($".")+".nearby")

func _on_Proximity_body_exited(body):
	body.remove_from_group(str($".")+".nearby")

func _process(delta):
	if !synkd:
		move()
