extends Node

@export var rock_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
const SCROLL_SPEED: int = 4
var screen_size: Vector2i
var ground_height: int
var rocks: Array
const ROCK_DELAY: int = 200
const ROCK_RANGE: int = 80

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("rocks", "queue_free")
	rocks.clear()
	generate_rocks()
	$Plane.reset();
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Plane.flying:
						$Plane.flap()
						check_stop()

func start_game():
	game_running = true
	$Plane.flying = true
	$Plane.flap()
	$RockTimer.start()

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for rock in rocks:
			rock.position.x -= SCROLL_SPEED


func _on_rock_timer_timeout():
	generate_rocks()

func generate_rocks():
	var rock = rock_scene.instantiate()
	rock.position.x = screen_size.x + ROCK_DELAY
	rock.position.y = (screen_size.y - ground_height) / 2  + randi_range(-ROCK_RANGE, ROCK_RANGE)
	rock.hit.connect(rock_hit)
	rock.scored.connect(scored)
	add_child(rock)
	rocks.append(rock)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func check_stop():
	if $Plane.position.y < 0:
		$Plane.falling = true
		stop_game()

func stop_game():
	$RockTimer.stop()
	$Plane.flying = false
	$GameOver.show()
	game_running = false
	game_over = true
	
func rock_hit():
	$Plane.falling = true
	stop_game()

func _on_ground_hit():
	$Plane.falling = true
	stop_game()

func _on_game_over_restart():
	if game_running:
		pass
	else:
		new_game()
