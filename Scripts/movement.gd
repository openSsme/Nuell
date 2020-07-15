extends Node2D

export (int) var speed = 100

var velocity = Vector2()
onready var target = $Ether/Ghost/Probe.get_collider()

func get_input():
	$Ether/Ghost/Probe.look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func mvmt():
	if $Ether/Ghost.visible && $Ether/Ghost/Probe.enabled:
		velocity = $Ether/Ghost.move_and_slide(velocity)
		if velocity.x > 1 or velocity.x < 0 or velocity.y > 1 or velocity.y < 0:
			$Ether/Ghost/Sprite.play("run")
		else:
			$Ether/Ghost/Sprite.play("idle")
	else:
		if target != null and target.can_move:
			velocity = target.move_and_slide(velocity)
			$Ether/Ghost.position = target.position
			if velocity.x > 1 or velocity.x < 0 or velocity.y > 1 or velocity.y < 0:
				target.get_node("Sprite").play("run")
			else:
				target.get_node("Sprite").play("idle")
		else:
			$Ether/Ghost.visible = true
			$Ether/Ghost/Probe.enabled = true
			$Ether/Ghost/Sprite.play("idle")

func synk():
	if Input.is_action_just_released('synk'):
		if $Ether/Ghost/Probe.is_colliding() and $Ether/Ghost/Probe.get_collider() != null:
			target = $Ether/Ghost/Probe.get_collider()
			$Ether/Ghost.position = target.position
			$Ether/Ghost.visible = false
			$Ether/Ghost/Probe.enabled = false
			target.synkd = true

		elif target:
				target.synkd = false
				target = null
				$Ether/Ghost.visible = true
				$Ether/Ghost/Probe.enabled = true

func tether():
	if $Ether/Ghost/Probe.is_colliding():
		target = $Ether/Ghost/Probe.get_collider()
	if Input.is_action_just_released('tether'):
		pass

func _process(delta):
	synk()

func _physics_process(delta):
	get_input()
	mvmt()
	
