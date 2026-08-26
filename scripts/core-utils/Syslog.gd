extends Node
class_name Syslog
## Static logging API. Formats a leveled message and hands it to LogUtility.

enum LogLevel { ERROR, WARNING, INFO, DEBUG }

## Only messages at this level or more severe (lower enum value) are logged.
const ACTIVE_LOG_LEVEL: LogLevel = LogLevel.DEBUG

const LEVEL_LABEL: Dictionary = {
    LogLevel.ERROR: "  [ERROR]",
    LogLevel.WARNING: "[WARNING]",
    LogLevel.INFO: "   [INFO]",
    LogLevel.DEBUG: "  [DEBUG]",
}

const LEVEL_COLOR: Dictionary = {
    LogLevel.ERROR: "#ff7a7a",
    LogLevel.WARNING: "#ffd166",
    LogLevel.INFO: "#6ecbff",
    LogLevel.DEBUG: "#9aa0a6",
}

static func _log_msg(p_messages: Array, p_level: LogLevel) -> void:
    if ACTIVE_LOG_LEVEL < p_level:
        return

    var msg: String = _join_msg(p_messages)
    var plain_msg: String = "%s %s | %s" % [Util.get_uptime_formatted(), LEVEL_LABEL[p_level], msg]
    var colored_msg: String = "[color=%s]%s[/color]" % [LEVEL_COLOR[p_level], plain_msg]

    LogUtility.write_log(colored_msg, plain_msg)

static func _join_msg(p_messages: Array) -> String:
    var msg: String = ""

    for message: Variant in p_messages:
        msg += str(message)

    return msg

@warning_ignore_start("untyped_declaration") #Types unsupported on variadic arguments
static func error(...p_messages) -> void:
    _log_msg(p_messages, LogLevel.ERROR)

static func warning(...p_messages) -> void:
    _log_msg(p_messages, LogLevel.WARNING)

static func info(...p_messages) -> void:
    _log_msg(p_messages, LogLevel.INFO)

static func debug(...p_messages) -> void:
    _log_msg(p_messages, LogLevel.DEBUG)
@warning_ignore_restore("untyped_declaration")
