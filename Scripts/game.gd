extends Node2D


@onready var user_input = $Text/user_input
@onready var text_maker = $Text/TextMaker


## menu button
# takes the player back to the home page
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


# checks computer displayed text with submitted player text
func _on_user_input_text_changed(new_text: String) -> void:
	var c_text: String = text_maker.text
	
	# check if it matches computer text (c_text)
	if (c_text.substr(0, 1).similarity(new_text.substr(0, 1))):
		c_text = c_text.substr(1, c_text.length())
		user_input.text = ""
	
	update_c_text(c_text)
	pass


func update_c_text(c_text: String) -> void:
	text_maker.text = c_text
	
	const C_TEXT_LENGTH: int = 20
	if (c_text.length() < C_TEXT_LENGTH):
		text_maker.text += text_maker.generate_text(C_TEXT_LENGTH)


# initialization
func _ready() -> void:
	update_c_text("")
