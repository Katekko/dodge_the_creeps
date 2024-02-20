extends Node

@export var mob_scene: PackedScene

@onready var player = $Player
@onready var start_timer : Timer = $StartTimer
@onready var score_timer : Timer = $ScoreTimer
@onready var mob_timer : Timer = $MobTimer
@onready var start_position: Marker2D = $StartPosition
@onready var music : AudioStreamPlayer = $Music
@onready var death_sound : AudioStreamPlayer = $DeathSound

@onready var HUD = $HUD


var score

func _ready():
	mob_timer.start()

func new_game():
	score = 0
	HUD.update_score(score)
	HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	player.start(start_position.position)
	mob_timer.stop()
	start_timer.start()
	
func _on_start_timer_timeout():
	mob_timer.start()
	score_timer.start()
	
func _on_score_timer_timeout():
	score += 1
	HUD.update_score(score)

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

func game_over():
	score_timer.stop()
	mob_timer.stop()
	HUD.show_game_over()
	music.stop()
	death_sound.play()
	music.stop()
	await get_tree().create_timer(death_sound.stream.get_length()).timeout
	music.play()
	
