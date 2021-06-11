extends AnimatedSprite

export (float) var speed = 100

var rng
var animations
var direction = 1

func initialize():
	rng = RandomNumberGenerator.new()
	animations = ["male_walk", "female_walk"]

func _move_to_right():
	direction = 1
	self.flip_h = 0

func _move_to_left():
	direction = -1
	self.flip_h = 1

func _process(delta):
	position.x += direction * speed * delta
	

func set_male_animation():
	self.play("male_walk")

func set_female_animation():
	self.play("female_walk")

func set_zombie_animation():
	self.play("zombie_walk")

func set_random_animation(is_sick):
	if !is_sick:
		randomize()
		self.play(animations[randi() % animations.size()])
	else:
		set_zombie_animation()

func set_position_and_movement_direction(pos:Vector2):
	position = pos
	if pos.x > 0:
		_move_to_left()
	else:
		_move_to_right()
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()
