extends Node2D

# El valor representativo de la barra es la posición del hijo en la que se
# encuentra en el panel de escenas de HealthBarGroup, por ejemplo "Social" es el
# hijo que están en la posición 3. 
# No es la mejor práctica, pero no se me ocurrió otra manera de acceder a las
# escenas hijas de las barras
const scene_numbers_bars = {
	"Cultural": 0,
	"Economico": 1,
	"Salud": 2,
	"Social": 3
}
var card_type
var card_multipliers
var bar_group
var actual_bar
var game_over
var main_node

onready var label = $TextLabel

func _ready():
	label.add_font_override("normal_font", ResourceLoader.load("res://assets/Fonts/Snowday.tres"))

func initialize(type, description, multipliers, main, has_lost = false) -> void:
	card_type = type
	card_multipliers = multipliers
	bar_group = main.get_child(2)
	$TextLabel.text = description
	game_over = has_lost
	main_node = main

func _on_CheckButton_pressed() -> void:
	if game_over:
		main_node.restart_game()
	else:
		DeckOfCards.checked(card_multipliers)
		_update_if_exists_actual_bar()
		call_deferred("_remove")

func _on_XButton_pressed() -> void:
	card_multipliers=[-card_multipliers[0], -card_multipliers[1], -card_multipliers[2], -card_multipliers[3]]
	DeckOfCards.checked(card_multipliers)
	_update_if_exists_actual_bar()
	call_deferred("_remove")

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()

func feedback() -> void:
	if card_type != "Introduccion" && card_type != "RoundResume" :
		actual_bar = bar_group.get_child(scene_numbers_bars[card_type])
	if actual_bar:
		actual_bar.change_textlabel()

func _update_if_exists_actual_bar() -> void:
	if actual_bar:
		actual_bar.update_state()

func prepend_to_description(description:String):
	$TextLabel.text = $TextLabel.text.insert(0, description)

func _on_CheckButton_ready() -> void:
	self.feedback()

func _on_XButton_ready() -> void:
	self.feedback()
