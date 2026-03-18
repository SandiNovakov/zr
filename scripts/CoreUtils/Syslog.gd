extends Node
class_name Syslog

@warning_ignore_start("untyped_declaration") #Types unsupported on variadic arguments
static func _log_msg(messages: Array, log_level: CoreConfig.LogLevel) -> void:
    if CoreConfig.LOG_LEVEL < log_level:
        return
    
    var msg: String = ""
    
    for message in messages:
        msg += str(message)
    
    msg = CoreConfig.LOG_LEVEL_MAP.get(log_level, "") + msg
    
    LogUtility.write_log(msg)

static func error(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.ERROR)

static func warning(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.WARNING)

static func info(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.INFO)

static func debug(...messages) -> void:
    _log_msg(messages, CoreConfig.LogLevel.DEBUG)
@warning_ignore_restore("untyped_declaration") #Types unsupported on variadic arguments
