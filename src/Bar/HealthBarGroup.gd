extends Node2D

onready var economia_bar = $Economico
onready var salud_bar = $Salud
onready var cultural_bar = $Cultural
onready var social_bar = $Social
onready var overall_bar = $OverallBar
var global_timer
var pedestrian_spawner

func initialize(timer:Timer, clock:Node2D, multipliers, spawner):
	pedestrian_spawner = spawner
	economia_bar.initialize(timer, clock, multipliers['Economico'])
	salud_bar.initialize(timer, clock, multipliers['Salud'])
	cultural_bar.initialize(timer, clock, multipliers['Cultural'])
	social_bar.initialize(timer, clock, multipliers['Social'])
	_update_overall_value()
	timer.connect("timeout", self, "_update_overall_value")

func _update_overall_value():
	pedestrian_spawner.set_salud_current_value(salud_bar.get_healthbar_value())
	var overall_value = economia_bar.get_value() + salud_bar.get_value() + cultural_bar.get_value() + social_bar.get_value()
	overall_bar.set_value(overall_value)

func get_percentages():
	var percentages = []
	percentages.append(economia_bar.get_value())
	percentages.append(salud_bar.get_value())
	percentages.append(cultural_bar.get_value())
	percentages.append(social_bar.get_value())
	return percentages

func set_multipliers(multipliers):
	economia_bar.set_multiplier(multipliers['Economico'])
	salud_bar.set_multiplier(multipliers['Salud'])
	cultural_bar.set_multiplier(multipliers['Cultural'])
	social_bar.set_multiplier(multipliers['Social'])
