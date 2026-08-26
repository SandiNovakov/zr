extends Node

var refs: Dictionary = {}

func get_root() -> Node:
    return _get_ref(&"root") as Node

func get_title() -> Node:
    return _get_ref(&"title") as Node

func get_player() -> Actor2D:
    return _get_ref(&"player") as Actor2D

func get_main() -> Node:
    return _get_ref(&"main") as Node
    
func get_world_env() -> WorldEnvironment:
    return _get_ref(&"world_env") as WorldEnvironment

func get_background() -> SubViewport:
    return _get_ref(&"background") as SubViewport

func get_ui() -> CanvasLayer:
    return _get_ref(&"ui") as CanvasLayer





#------------------------------------------------------------------------------#
#                            REGISTERING FUNCTIONS                             #
#------------------------------------------------------------------------------#
func register_ref(p_key: StringName, p_value: Object, p_replace: bool = false) -> void:
    if refs.has(p_key) and is_instance_valid(refs[p_key]) and not p_replace:
        Syslog.error("%s tried to register '%s', but already registered." % [p_value.name, p_key])
        return

    refs[p_key] = p_value
    Syslog.info("Registered '%s': %s" % [p_key, p_value.name])

    p_value.tree_exiting.connect(func() -> void:
        clear_ref(p_key, p_value), CONNECT_ONE_SHOT)

## Use expected when clearing to prevent accidentally clearing an unrelated value.
func clear_ref(p_key: StringName, p_expected: Node = null) -> void:
    if not refs.has(p_key):
        return

    if p_expected != null and refs[p_key] != p_expected:
        Syslog.error("Tried to clear '%s' but caller does not match registered object." % p_key)
        return

    refs.erase(p_key)
    Syslog.info("Cleared '%s'" % p_key)

func _get_ref(p_key: StringName) -> Object:
    if refs.has(p_key):
        if is_instance_valid(refs[p_key]):
            return refs[p_key]

        refs.erase(p_key)

    return null
