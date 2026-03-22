extends Node
class_name ActorController

@onready var master: Actor2D = get_parent()

func is_shoot_once() -> bool:
    #return InputBuffer.is_action_press_buffered(&"shoot")
    return Input.is_action_just_pressed(&"shoot")

func is_shoot() -> bool:
    return Input.is_action_pressed(&"shoot")

func is_dash() -> bool:
    return InputBuffer.is_action_press_buffered(&"dash")

func get_action_buffered(action: StringName) -> bool:
    Syslog.warning('Used deprecated function ActorController.get_action_buffered()! See code for more details.')
    #ActorController will eventually be replaced with a generic version of the controller that will allow us to
    #give instructions based on ai, not just player input, so any functions to do with input will have to be done away with for now.
    
    return InputBuffer.is_action_press_buffered(action)

func get_move_dir(allow_slow: bool = true) -> Vector2:
    var move_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
    if allow_slow and Input.is_action_pressed("slow"):
        move_dir *= 0.5
    
    return move_dir

func get_look_dir() -> Vector2:
    match InputDeviceManager.current_input_device:
        InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
            return (master.get_global_mouse_position() - master.global_position).normalized()
        InputDeviceManager.InputDevices.CONTROLLER:             
            return Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
        _:
            Syslog.error('Current input device is not in InputDevices enum!')
            return Vector2.ZERO
        
