extends RigidBody2D

@onready var animated_sprited: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var mob_types = animated_sprited.sprite_frames.get_animation_names()
	animated_sprited.play(mob_types[randi() % mob_types.size()])
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
