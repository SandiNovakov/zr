extends Node
class_name Syslog

static func _log_msg(messages: Array, log_level: CoreConfig.LogLevel) -> void: 
    if CoreConfig.LOG_LEVEL < log_level:
        return
        
    var msg := _join_msg(messages)
    
    var destinations: Dictionary = CoreConfig.LOG_DESTINATIONS
    
    if destinations[CoreConfig.LogDestination.PRINT]:
        var f_msg: String = _format_msg(msg, log_level, CoreConfig.LogDestination.PRINT)
        LogUtility.write_log(f_msg, CoreConfig.LogDestination.PRINT)
        
    if destinations[CoreConfig.LogDestination.PRINT_RICH]:
        var f_msg: String = _format_msg(msg, log_level, CoreConfig.LogDestination.PRINT_RICH)
        LogUtility.write_log(f_msg, CoreConfig.LogDestination.PRINT_RICH)
        
    if destinations[CoreConfig.LogDestination.LOG_FILE]:
        var f_msg: String = _format_msg(msg, log_level, CoreConfig.LogDestination.LOG_FILE)
        LogUtility.write_log(f_msg, CoreConfig.LogDestination.LOG_FILE)
        
    if destinations[CoreConfig.LogDestination.HTML_FILE]:
        var f_msg: String = _format_msg(msg, log_level, CoreConfig.LogDestination.HTML_FILE)
        LogUtility.write_log(f_msg, CoreConfig.LogDestination.HTML_FILE)
               
static func _format_msg(msg: String, log_level: CoreConfig.LogLevel, destination: CoreConfig.LogDestination, add_timestamp: bool = true) -> String:
    var f_msg: String = msg
    
    if add_timestamp:
        f_msg = "%s %s | %s" % [Util.get_uptime_formatted(), CoreConfig.LOG_LEVEL_MAP[log_level], msg]
        
    match destination:
        CoreConfig.LogDestination.PRINT_RICH: # bbcode
            var color: String = CoreConfig.LOG_LEVEL_COLOR_MAP[log_level]
            f_msg = "[color=%s]%s[/color]" % [color, f_msg]
            
        CoreConfig.LogDestination.HTML_FILE: # inline css
            var color: String = CoreConfig.LOG_LEVEL_COLOR_MAP[log_level]
            f_msg = "<p style='color: %s;'>%s</p>" % [color, f_msg]

    return f_msg

static func _join_msg(messages: Array) -> String: 
    var msg: String = ""
    
    for message: Variant in messages:
        msg += str(message)
    
    return msg

@warning_ignore_start("untyped_declaration") #Types unsupported on variadic arguments
static func error(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.ERROR)

static func warning(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.WARNING)

static func info(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.INFO)

static func debug(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.DEBUG)
@warning_ignore_restore("untyped_declaration") #Types unsupported on variadic arguments
