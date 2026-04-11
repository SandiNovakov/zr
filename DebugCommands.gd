extends Node

var commands: Array[Command] = [
    Command.new(
        hello,
        []
    ),
    
    Command.new(
        resolution,
        [
            CommandArg.new("width", ArgTypes.INT, 640),
            CommandArg.new("height", ArgTypes.INT, 480)
        ]
    ),
]

# Updated function signature - no more Array parameter!
func resolution(width: int, height: int) -> String:
    var mode = DisplayServer.window_get_mode()
    if mode != DisplayServer.WINDOW_MODE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    DisplayServer.window_set_size(Vector2i(width, height))

    return "Resolution set to %dx%d" % [width, height]

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

# Keep your existing hello function unchanged
func hello() -> String:
    return "hello from cruxade with love!"

func get_command(command_name: StringName) -> Variant:
    for command: Command in commands:
        if command.callable.get_method() == command_name:
            return command
    
    return null

func get_command_arg_count(command: Command, required_only: bool = false) -> int:
    if required_only == false:
        return command.args.size()
    
    else:
        var count: int = 0
        
        for i: int in range(0, command.args.size(), 1):
            if command.args[i].default == null:
                count += 1
        
        return count

func is_valid_type(expected_type: ArgTypes, value: String) -> bool:
    value = value.to_lower()
    
    match expected_type:
        ArgTypes.INT:
            return value.is_valid_int()
            
        ArgTypes.FLOAT:
            return value.is_valid_float()
            
        ArgTypes.STRING:
            return true
            
        ArgTypes.BOOL:
            return bool_map.has(value)
            
        ArgTypes.LEVEL:
            return level_map.has(value)
            
        ArgTypes.BOOL_LEVEL:
            return bool_level_map.has(value)
            
        _:
            return false

func is_within_range(expected_type: ArgTypes, value: String, min_val: Variant, max_val: Variant) -> bool:
    match expected_type:
        ArgTypes.INT:
            var v: int = int(value)
            
            if min_val != null and v < int(min_val):
                return false
            if max_val != null and v > int(max_val):
                return false
                
        ArgTypes.FLOAT:
            var v: float = float(value)
            
            if min_val != null and v < float(min_val):
                return false
            if max_val != null and v > float(max_val):
                return false
                
        ArgTypes.STRING:
            var count: int = value.length()
            
            if min_val != null and count < int(min_val):
                return false
            if max_val != null and count > int(max_val):
                return false
                
        _:
            pass
    
    return true

func convert_value(expected_type: ArgTypes, value: String) -> Variant:
    value = value.to_lower()
    
    match expected_type:
        ArgTypes.INT:
            return int(value)
            
        ArgTypes.FLOAT:
            return float(value)
            
        ArgTypes.STRING:
            return value
            
        ArgTypes.BOOL:
            return bool_map.get(value)
            
        ArgTypes.LEVEL:
            return level_map.get(value)
            
        ArgTypes.BOOL_LEVEL:
            return bool_level_map.get(value)
            
        _:
            return null    

func type_to_string(t: ArgTypes) -> String:
    match t:
        ArgTypes.INT: return "int"
        ArgTypes.FLOAT: return "float"
        ArgTypes.STRING: return "string"
        ArgTypes.BOOL: return "bool"
        ArgTypes.LEVEL: return "level"
        ArgTypes.BOOL_LEVEL: return "bool_level"
        _: return "unknown"

func build_arg_syntax(arg: CommandArg) -> String:
    var type_str := type_to_string(arg.type)
    
    var constraint := ""
    
    match arg.type:
        ArgTypes.INT, ArgTypes.FLOAT:
            if arg.min_val != null or arg.max_val != null:
                constraint = " (%s..%s)" % [
                    arg.min_val if arg.min_val != null else "-inf",
                    arg.max_val if arg.max_val != null else "+inf"
                ]
                
        ArgTypes.STRING:
            if arg.min_val != null or arg.max_val != null:
                constraint = " (len %s..%s)" % [
                    arg.min_val if arg.min_val != null else "0",
                    arg.max_val if arg.max_val != null else "∞"
                ]
                
        ArgTypes.BOOL:
            constraint = " (on/off)"
            
        ArgTypes.LEVEL:
            constraint = " (low/medium/high)"
            
        ArgTypes.BOOL_LEVEL:
            constraint = " (off/low/medium/high)"
    
    var base := "%s:%s%s" % [arg.display, type_str, constraint]
    
    # optional vs required
    if arg.default != null:
        return "[%s=%s]" % [base, str(arg.default)]
    else:
        return "<%s>" % base
        
func get_command_usage(command_name: StringName) -> String:
    var command: Command = get_command(command_name)
    
    if command == null:
        return "No such command."
    
    var parts: Array[String] = []
    
    for arg in command.args:
        parts.append(build_arg_syntax(arg))
    
    return "%s %s" % [
        command_name,
        " ".join(parts)
    ]

func execute_command(command_name: StringName, args: Array) -> String:
    var command: Command
    var null_ref: Variant = get_command(command_name)
    
    if null_ref == null:
        return "No such command exists."
    else:
        command = null_ref
    
    if args.size() == 1 and args[0] == "?":
        return "Usage: %s" % get_command_usage(command_name)
    
    var argc_min: int = get_command_arg_count(command, true)
    var argc_max: int = get_command_arg_count(command, false)
    
    if args.size() < argc_min or args.size() > argc_max:
        return "Wrong number of arguments. Expected at least %s and at most %s.\nUsage: %s" % [
            argc_min, argc_max, get_command_usage(command_name)
        ]
    
    var final_args: Array = []
    var errors: Array[String] = []
    
    for i in range(command.args.size()):
        var arg_def: CommandArg = command.args[i]
        
        # handle missing optional args
        if i >= args.size():
            final_args.append(arg_def.default)
            continue
        
        var raw_value: String = str(args[i])
        
        # --- type check ---
        if not is_valid_type(arg_def.type, raw_value):
            errors.append(
                "Arg %d (%s): invalid type. Expected %s." % [
                    i, arg_def.display, type_to_string(arg_def.type)
                ]
            )
            continue
        
        # --- range check ---
        if not is_within_range(arg_def.type, raw_value, arg_def.min_val, arg_def.max_val):
            errors.append(
                "Arg %d (%s): value out of range." % [
                    i, arg_def.display
                ]
            )
            continue
        
        # --- conversion ---
        var converted: Variant = convert_value(arg_def.type, raw_value)
        
        if converted == null and arg_def.type != ArgTypes.STRING:
            errors.append(
                "Arg %d (%s): failed to convert value." % [
                    i, arg_def.display
                ]
            )
            continue
        
        final_args.append(converted)
    
    # --- error handling ---
    if errors.size() > 0:
        return "%s\nUsage: %s" % [
            "\n".join(errors),
            get_command_usage(command_name)
        ]
    
    # --- execution ---
    return command.callable.callv(final_args)
