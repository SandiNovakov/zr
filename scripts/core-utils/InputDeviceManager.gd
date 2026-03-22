extends Node

const JOY_DEADZONE := 0.2

enum InputDevices { # Only for actual input logic
	CONTROLLER,
	KEYBOARD_MOUSE
}

const InputDevicesName := {
	InputDevices.CONTROLLER: "CONTROLLER",
	InputDevices.KEYBOARD_MOUSE: "KEYBOARD_MOUSE"
}

enum InputIcons { # Only for display
	XBOX,
	PS,
	NINTENDO,
	KEYBOARD_MOUSE
}

var current_input_device: InputDevices = InputDevices.KEYBOARD_MOUSE
var current_input_icons: InputIcons = InputIcons.KEYBOARD_MOUSE

func _input(event: InputEvent) -> void:
	
	var info_current_device: InputDevices = current_input_device;
		
	if event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > JOY_DEADZONE):
		current_input_device = InputDevices.CONTROLLER
	if event is InputEventMouse or event is InputEventKey:
		current_input_device = InputDevices.KEYBOARD_MOUSE
	
	if info_current_device != current_input_device:
		Syslog.info("Input device changed from %s to %s" % [InputDevicesName[info_current_device], InputDevicesName[current_input_device]])
