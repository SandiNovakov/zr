extends Node

# How long an input stays valid (milliseconds)
const BUFFER_WINDOW: int = 150

# action -> last pressed time (ms)
var action_timestamps: Dictionary = {}

# prevents repeated consumption
var consumed_actions: Dictionary = {}

# prevents multiple registrations in the same frame
var last_frame: Dictionary = {}

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
    if event.is_echo():
        return

    for action in InputMap.get_actions():
        if InputMap.event_is_action(event, action) and event.is_pressed():
            _register_action(action)
            break


func _register_action(action: String) -> void:
    var frame := Engine.get_process_frames()

    # prevent duplicate registration in same frame
    if last_frame.get(action, -1) == frame:
        return

    last_frame[action] = frame
    action_timestamps[action] = Time.get_ticks_msec()
    consumed_actions[action] = false


func is_action_press_buffered(action: StringName) -> bool:
    return pop_action_buffered(action)

# Main API: returns true ONCE per press (auto-consumes)
func pop_action_buffered(action: String) -> bool:
    if not action_timestamps.has(action):
        return false

    if consumed_actions.get(action, false):
        return false

    var delta: int = Time.get_ticks_msec() - action_timestamps[action]

    if delta <= BUFFER_WINDOW:
        consumed_actions[action] = true
        return true

    return false


# Optional: check without consuming
func is_action_recent(action: String) -> bool:
    return action_timestamps.has(action) \
        and (Time.get_ticks_msec() - action_timestamps[action]) <= BUFFER_WINDOW


# Optional: get how long ago action was pressed (ms)
func get_action_age(action: String) -> int:
    if not action_timestamps.has(action):
        return INF
    return Time.get_ticks_msec() - action_timestamps[action]


# Cleanup expired inputs
func _process(_delta: float) -> void:
    var now := Time.get_ticks_msec()

    for action in action_timestamps.keys():
        if now - action_timestamps[action] > BUFFER_WINDOW:
            consumed_actions[action] = true
