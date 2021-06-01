extends Node2D

signal low_bar(bar_type)
signal high_bar(bar_type)

var bar_red = preload("res://assets/Bar/barHorizontal_red.png")
var bar_green = preload("res://assets/Bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/Bar/barHorizontal_yellow.png")

export (float) var multiplier = 1
export (String) var label = ""
export (float) var percentage = 1

onready var healthbar = $HealthBar
onready var healthbar_textlabel = $HealthBarLabel
onready var good_event_decider = GoodEventDecider

var global_clock
var speed_multiplier
var remaining_ticks_before_emit = 10

func initialize(timer:Timer, clock:Node2D, deck_multiplier):
	good_event_decider.set_timer(timer)
	speed_multiplier = 1
	multiplier = deck_multiplier
	global_clock = clock
	global_clock.connect("speed_updated", self, "_set_speed_multiplier")
	_update_value()
	timer.connect("timeout", self, "_update_value")
	self.connect("low_bar", DeckOfCards, "raise_low_card")
	self.connect("high_bar", DeckOfCards, "raise_high_card")

func set_value(value:float):
	healthbar.value = value
	_update_healthbar()

func get_value():
	return healthbar.value * percentage

func set_multiplier(deck_multiplier):
	multiplier = deck_multiplier

func _ready():
	healthbar_textlabel.set_text(label)

func _set_speed_multiplier(hours_per_second):
	speed_multiplier = hours_per_second

func _is_low():
	return healthbar.value < healthbar.max_value * 0.30

func _is_high():
	return healthbar.value > healthbar.max_value * 0.70

func _update_value():
	healthbar.value = healthbar.value + speed_multiplier * multiplier
	remaining_ticks_before_emit = clamp(remaining_ticks_before_emit-1, 0, 10)
	if _can_emit():
		if _is_low():
			_restart_emit_count()
			emit_signal("low_bar", healthbar_textlabel.text)
		if !_is_at_max_value() && _is_high() && GoodEventDecider.can_emit():
			emit_signal("high_bar", healthbar_textlabel.text)
	_update_healthbar()

func _is_at_max_value():
	return healthbar.value == healthbar.max_value

func _can_emit():
	return remaining_ticks_before_emit == 0

func _restart_emit_count():
	remaining_ticks_before_emit = 10

func _update_healthbar():
	healthbar.texture_progress = bar_green
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red

func change_textlabel():
	healthbar_textlabel.clear()
	healthbar_textlabel.append_bbcode("[wave amp=25 freq=10][color=blue]"+label+"[/color][/wave]")

func update_state():
	healthbar_textlabel.set_text(label)
