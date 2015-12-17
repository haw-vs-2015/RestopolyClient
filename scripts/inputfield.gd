
extends LineEdit

func _ready():
	set_process_input(true)

func _input(ev):
	if ev.is_action("my_ui_accept") and !ev.is_echo():
		if ev.is_pressed():
			get_parent()._onSendPressed()

