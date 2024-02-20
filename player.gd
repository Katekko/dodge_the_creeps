extends Area2D

signal hit

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var screen_size: Vector2 = get_viewport_rect().size

@export var speed = 400

func _ready():
	hide()
	set_process(false)
	collision_shape.disabled = true

func start(pos):
	set_process(true)
	position = pos
	show()
	collision_shape.disabled = false

func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite.play()
	else:
		animated_sprite.stop()
		
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(_body):
	hide()
	hit.emit()
	collision_shape.set_deferred("disabled", true)
	
