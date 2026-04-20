extends Node

var refs: Dictionary = {}

func get_player() -> Actor2D:
    return _get_ref(&"player") as Actor2D

func get_main() -> Node:
    return _get_ref(&"main") as Node
    
func get_world_env() -> WorldEnvironment:
    return _get_ref(&"world_env") as WorldEnvironment

func get_ui() -> CanvasLayer:
    return _get_ref(&"ui") as CanvasLayer





#------------------------------------------------------------------------------#
#                            REGISTERING FUNCTIONS                             #
#------------------------------------------------------------------------------#
@warning_ignore_start("untyped_declaration") # Reason: vibe-coded
@warning_ignore_start("inferred_declaration")
func register_ref(key: StringName, value: Object, replace := false) -> void:
    if refs.has(key) and is_instance_valid(refs[key]) and not replace:
        Syslog.error("%s tried to register '%s', but already registered." % [value.name, key])
        return

    refs[key] = value
    Syslog.info("Registered '%s': %s" % [key, value.name])
    
    value.tree_exiting.connect(func():
        clear_ref(key, value), CONNECT_ONE_SHOT)

## Use expected when clearing to prevent accidentally clearing an unrelated value.
func clear_ref(key: StringName, expected: Node = null) -> void:
    if not refs.has(key):
        return

    if expected != null and refs[key] != expected:
        Syslog.error("Tried to clear '%s' but caller does not match registered object." % key)
        return

    refs.erase(key)
    Syslog.info("Cleared '%s'" % key)

func _get_ref(key: StringName) -> Object:
    if refs.has(key):
        if is_instance_valid(refs[key]):
            return refs[key]

        refs.erase(key)

    return null
