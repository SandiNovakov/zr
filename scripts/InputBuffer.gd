extends Node

var buffer_time: float = 9.0/60.0
var actions: Array

func _unhandled_input(event: InputEvent) -> void:
    for action in InputMap.get_actions():
        if Input.is_action_just_pressed(action):
            var found: bool = false
            for i: Dictionary in actions:
                
                if i["name"] == action:
                    i["timestamp"] = Time.get_ticks_usec()
                    i["consumed"] = false
                    found = true
            if not found:                    
                actions.append({
                    "name": action,
                    "timestamp": Time.get_ticks_usec(),
                    "consumed": false
            })

func is_action_press_buffered(action: StringName) -> bool:
    for i: Dictionary in actions:
        if i["name"] == action:
            if Time.get_ticks_usec() - i["timestamp"] <= Util.to_usec(buffer_time) and i["consumed"] == false:
                i["consumed"] = true
                return true
    
    return false
