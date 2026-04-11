extends Node

var commands: Array[Command] = [
    Command.new(help),
    Command.new(hello),
    Command.new(fps),
    Command.new(fullscreen),
    
    Command.new(resolution, [
        CommandArg.new("width", ArgTypes.INT, 640),
        CommandArg.new("height", ArgTypes.INT, 480)
    ]),
    
    Command.new(set_resolution_scale, [
        CommandArg.new("preset", ArgTypes.LEVEL)
    ]),
    
    Command.new(set_post_processing, [
        CommandArg.new("value", ArgTypes.BOOL)
    ]),
    
    Command.new(set_vsync, [
        CommandArg.new("value", ArgTypes.BOOL)
    ]),
    
    Command.new(set_physics_interpolation, [
        CommandArg.new("value", ArgTypes.BOOL)
    ]),
    
    Command.new(set_tps, [
        CommandArg.new("value", ArgTypes.INT, 1, 120, 60)  # min 1, max 120, default 60
    ]),
    
    Command.new(set_vibration, [
        CommandArg.new("strength", ArgTypes.BOOL_LEVEL)
    ]),
]

func resolution(width: int, height: int) -> String:
    var mode = DisplayServer.window_get_mode()
    if mode != DisplayServer.WINDOW_MODE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    DisplayServer.window_set_size(Vector2i(width, height))

    return "Resolution set to %dx%d" % [width, height]
    
func hello() -> String:
    return "hello from cruxade with love."

func fps() -> String:
    var fps_visible: bool = DebugConsoleGui.fps.visible
    if not fps_visible:
        DebugConsoleGui.fps.visible = true
        return "FPS counter on."
    else:
        DebugConsoleGui.fps.visible = false
        return "FPS counter off."
    
func fullscreen() -> String:
    HotkeysManager.toggle_borderless() #TODO: This is all wrong lmao
    return "Toggled fullscreen mode."

func set_resolution_scale(preset: Levels) -> String:
    var scale_map = {
        Levels.LOW: 0.5,
        Levels.MEDIUM: 0.75,
        Levels.HIGH: 1.0
    }
    
    var scale = scale_map[preset]
    get_viewport().scaling_3d_scale = scale
    return "Resolution scale set to %s preset (%.0f%%)." % [preset, scale * 100]

func set_post_processing(value: bool) -> String:
    var env: Environment = get_node("/root/Main/WorldEnvironment").environment
    var msg: String
        
    if env == null:
        Syslog.error("No WorldEnvironment found!")
        return "No WorldEnvironment found!"
    
    match value:
        true:
            env.glow_enabled = true
        false:
            env.glow_enabled = false
        _:
            pass

    return "post_processing %s." % [Util.enabled_disabled(value)]

func set_vsync(value: bool) -> String:
    if value:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    else:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    
    return "V-sync %s." % [Util.enabled_disabled(value)]
    
func set_physics_interpolation(value: bool) -> String:
    get_tree().physics_interpolation = value
    return "Physics interpolation %s." % [Util.enabled_disabled(value)]
    
func set_tps(value: int) -> String:
    Engine.physics_ticks_per_second = value
    return "Physics TPS set to %d" % [value]

func set_vibration(strength: BoolLevels) -> String:
    match strength:
        BoolLevels.OFF:
            CoreConfig.enable_vibration = false
            CoreConfig.vibration_strength = 0.0
            return "Vibration disabled"
        BoolLevels.LOW:
            CoreConfig.enable_vibration = true
            CoreConfig.vibration_strength = 0.33
            return "Vibration set to low: 33%"
        BoolLevels.MEDIUM:
            CoreConfig.enable_vibration = true
            CoreConfig.vibration_strength = 0.66
            return "Vibration set to medium: 66%"
        BoolLevels.HIGH:
            CoreConfig.enable_vibration = true
            CoreConfig.vibration_strength = 1
            return "Vibration set to high: 100%"
        _:
            return "Vibration unchanged."

func help() -> String:
    var names: Array[String] = []
    
    # collect command names
    for cmd in commands:
        names.append(String(cmd.callable.get_method()))
    
    # sort alphabetically
    names.sort()
    
    if names.is_empty():
        return "No commands available."
        
    return "\n".join(names)









#------------------------------------------------------------------------------#
#                                 INTERNALS                                    #
#------------------------------------------------------------------------------#
enum ArgTypes{
    INT,
    FLOAT,
    STRING,
    BOOL, # YES/NO, TRUE/FALSE, ON/OFF
    LEVEL, # LOW, MEDIUM, HIGH
    BOOL_LEVEL, #OFF = 0, LOW, MEDIUM, HIGH
}

enum Levels {
    LOW,
    MEDIUM,
    HIGH,
}

enum BoolLevels {
    OFF,
    LOW,
    MEDIUM,
    HIGH,
}

var bool_map: Dictionary = {
    "on": true,
    "true": true,
    "yes": true,
    "off": false,
    "false": false,
    "no": false,
}


var level_map: Dictionary = {
    "low": Levels.LOW,
    "medium": Levels.MEDIUM,
    "high": Levels.HIGH,
}

var bool_level_map: Dictionary = {
    "off": BoolLevels.OFF,
    "low": BoolLevels.LOW,
    "medium": BoolLevels.MEDIUM,
    "high": BoolLevels.HIGH,
}

class CommandArg:
    var display: String
    var type: ArgTypes
    var min_val: Variant # Min number for floats and ints, character count for strings, unused for BOOL and LEVEL.
    var max_val: Variant # Max number for floats and ints, character count for strings, unused for BOOL and LEVEL.
    var default: Variant # Default value. Call will pass even if not supplied.
    
    func _init(p_display: String, p_type: ArgTypes, p_min_val: Variant = null, p_max_val: Variant = null, p_default: Variant = null) -> void:
        display = p_display
        type = p_type
        min_val = p_min_val
        max_val = p_max_val
        default = p_default

class Command:
    var callable: Callable # the name of the callable.
    var args: Array[CommandArg]
    
    func _init(p_callable: Callable, p_args: Array[CommandArg] = []) -> void:
        callable = p_callable
        args = p_args
