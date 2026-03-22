extends Node

# How long an input stays valid (milliseconds)
const BUFFER_WINDOW: int = 150

# action -> last pressed time (ms)
var action_timestamps: Dictionary = {}

# prevents repeated consumption if desired
var consumed_actions: Dictionary = {}

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

# Capture input at action level (device-agnostic)
func _input(event: InputEvent) -> void:
    for action in InputMap.get_actions():
        if event.is_action_pressed(action) and not event.is_echo():
            action_timestamps[action] = Time.get_ticks_msec()
            consumed_actions[action] = false

# Main API: check if action was pressed within buffer window
func is_action_press_buffered(action: String) -> bool:
    if not action_timestamps.has(action):
        return false

    if consumed_actions.get(action, false):
        return false

    var delta: int = Time.get_ticks_msec() - action_timestamps[action]
    return delta <= BUFFER_WINDOW


# Consume an action so it only triggers once per buffer window
func consume_action(action: String) -> void:
    consumed_actions[action] = true

# Hard invalidate (force reset state)
func invalidate_action(action: String) -> void:
    action_timestamps[action] = -INF
    consumed_actions[action] = true

# Check if action was recently pressed (without consumption)
func is_action_recent(action: String) -> bool:
    return action_timestamps.has(action) \
        and (Time.get_ticks_msec() - action_timestamps[action]) <= BUFFER_WINDOW

# Get how long ago action was pressed (ms)
func get_action_age(action: String) -> int:
    if not action_timestamps.has(action):
        return INF
    return Time.get_ticks_msec() - action_timestamps[action]
