extends Node

var autocomplete_state: Dictionary = {
    "query": "",
    "idx": 0,
}

func get_command(command_name: StringName) -> Variant:
    for command: DebugCommands.Command in DebugCommands.commands:
        if command.callable.get_method() == command_name:
            return command
    
    return null

func get_command_arg_count(command: DebugCommands.Command, required_only: bool = false) -> int:
    if required_only == false:
        return command.args.size()
    
    else:
        var count: int = 0
        
        for i: int in range(0, command.args.size(), 1):
            if command.args[i].default == null:
                count += 1
        
        return count

func is_valid_type(expected_type: DebugCommands.ArgTypes, value: String) -> bool:
    value = value.to_lower()
    
    match expected_type:
        DebugCommands.ArgTypes.INT:
            return value.is_valid_int()
            
        DebugCommands.ArgTypes.FLOAT:
            return value.is_valid_float()
            
        DebugCommands.ArgTypes.STRING:
            return true
            
        DebugCommands.ArgTypes.BOOL:
            return DebugCommands.bool_map.has(value)
            
        DebugCommands.ArgTypes.LEVEL:
            return DebugCommands.level_map.has(value)
            
        DebugCommands.ArgTypes.BOOL_LEVEL:
            return DebugCommands.bool_level_map.has(value)
            
        _:
            return false

func is_within_range(expected_type: DebugCommands.ArgTypes, value: String, min_val: Variant, max_val: Variant) -> bool:
    match expected_type:
        DebugCommands.ArgTypes.INT:
            var v: int = int(value)
            
            if min_val != null and v < int(min_val):
                return false
            if max_val != null and v > int(max_val):
                return false
                
        DebugCommands.ArgTypes.FLOAT:
            var v: float = float(value)
            
            if min_val != null and v < float(min_val):
                return false
            if max_val != null and v > float(max_val):
                return false
                
        DebugCommands.ArgTypes.STRING:
            var count: int = value.length()
            
            if min_val != null and count < int(min_val):
                return false
            if max_val != null and count > int(max_val):
                return false
                
        _:
            pass
    
    return true

func convert_value(expected_type: DebugCommands.ArgTypes, value: String) -> Variant:
    value = value.to_lower()
    
    match expected_type:
        DebugCommands.ArgTypes.INT:
            return int(value)
            
        DebugCommands.ArgTypes.FLOAT:
            return float(value)
            
        DebugCommands.ArgTypes.STRING:
            return value
            
        DebugCommands.ArgTypes.BOOL:
            return DebugCommands.bool_map.get(value)
            
        DebugCommands.ArgTypes.LEVEL:
            return DebugCommands.level_map.get(value)
            
        DebugCommands.ArgTypes.BOOL_LEVEL:
            return DebugCommands.bool_level_map.get(value)
            
        _:
            return null    

func type_to_string(t: DebugCommands.ArgTypes) -> String:
    match t:
        DebugCommands.ArgTypes.INT: return "int"
        DebugCommands.ArgTypes.FLOAT: return "float"
        DebugCommands.ArgTypes.STRING: return "string"
        DebugCommands.ArgTypes.BOOL: return "bool"
        DebugCommands.ArgTypes.LEVEL: return "level"
        DebugCommands.ArgTypes.BOOL_LEVEL: return "bool_level"
        _: return "unknown"

func build_arg_syntax(arg: DebugCommands.CommandArg) -> String:
    var type_str := type_to_string(arg.type)
    
    var constraint := ""
    
    match arg.type:
        DebugCommands.ArgTypes.INT, DebugCommands.ArgTypes.FLOAT:
            if arg.min_val != null or arg.max_val != null:
                constraint = " (%s..%s)" % [
                    arg.min_val if arg.min_val != null else "-inf",
                    arg.max_val if arg.max_val != null else "+inf"
                ]
                
        DebugCommands.ArgTypes.STRING:
            if arg.min_val != null or arg.max_val != null:
                constraint = " (len %s..%s)" % [
                    arg.min_val if arg.min_val != null else "0",
                    arg.max_val if arg.max_val != null else "∞"
                ]
                
        DebugCommands.ArgTypes.BOOL:
            constraint = " (on/off)"
            
        DebugCommands.ArgTypes.LEVEL:
            constraint = " (low/medium/high)"
            
        DebugCommands.ArgTypes.BOOL_LEVEL:
            constraint = " (off/low/medium/high)"
    
    var base := "%s:%s%s" % [arg.display, type_str, constraint]
    
    # optional vs required
    if arg.default != null:
        return "[%s=%s]" % [base, str(arg.default)]
    else:
        return "<%s>" % base
        
func get_command_usage(command_name: StringName) -> String:
    var command: DebugCommands.Command = get_command(command_name)
    
    if command == null:
        return "No such command."
    
    var parts: Array[String] = []
    
    for arg in command.args:
        parts.append(build_arg_syntax(arg))
    
    return "%s %s" % [
        command_name,
        " ".join(parts)
    ]

func get_autocomplete(query: String) -> String:
    if query == "":
        return ""
    
    if query != autocomplete_state.get("query"):
        autocomplete_state.set("query", query)
        autocomplete_state.set("idx", 0)
    
    var matches: Array[String] = []
    
    for cmd in DebugCommands.commands:
        var cmd_name: String = cmd.callable.get_method()
        if cmd_name.match(query+"*"):
            matches.append(cmd_name)
    
    if matches.is_empty():
        return query
    
    matches.sort()
    
    var idx: int = autocomplete_state.get("idx")
    var result: String = matches[idx]
    
    autocomplete_state.set("idx", (idx + 1) % matches.size())
    
    if get_command_arg_count(get_command(result)) > 0:
        result += " "
    
    return result
    
func execute_command(input: String) -> String:
    var command_name: StringName
    var args: Array = []
    
    Syslog.debug(input)
    
    input = input.trim_suffix(" ")
    var parts = input.split(" ", false)
    
    if parts.size() > 0:
        command_name = parts[0]
        args = parts.slice(1)
    else:
        command_name = input
    
    var command: DebugCommands.Command
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
        var arg_def: DebugCommands.CommandArg = command.args[i]
        
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
        
        if converted == null and arg_def.type != DebugCommands.ArgTypes.STRING:
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
    var msg: String = command.callable.callv(final_args)
    Syslog.info("Console: %s" % [msg])
    return msg
