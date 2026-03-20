extends Node
class_name ActorController

var move_dir: Vector2
var look_dir: Vector2

@onready var master: Actor2D = get_parent()

func is_dash() -> bool:
    Syslog.warning('Used deprecated function ActorController.is_dash()!')
    if InputBuffer.is_action_press_buffered("test"):
        return true
    return false  
    
func get_action_buffered(action: StringName) -> bool:
    if InputBuffer.is_action_press_buffered(action):
        return true
    return false  

func get_move_dir() -> Vector2:
    return Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")

func get_look_dir() -> Vector2:
    match InputDeviceManager.current_input_device:
        InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
            return (master.get_global_mouse_position() - master.global_position).normalized()
        InputDeviceManager.InputDevices.CONTROLLER:             
            return Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
        _:
            Syslog.error('Current input device is not in InputDevices enum!')
            return Vector2.ZERO
        
