extends Node

### ENUMS ###
enum LogLevel {
    ERROR = 0,
    WARNING = 1,
    INFO = 2,
    DEBUG = 3
}

enum LogDestination {PRINT, PRINT_RICH, LOG_FILE, HTML_FILE}

### EXPORTS ###
@export_category("Logger")
@export var log_level: LogLevel = LogLevel.DEBUG
@export var fake_debug_messages: bool = false

@export_group("Log Destinations")
@export var log_to_print: bool = false
@export var log_to_print_rich: bool = true
@export var log_to_text_file: bool = false
@export var log_to_html_file: bool = true

## Colors for each log level
@export_group("Log Colors")
@export var error_color: Color = Color("#ff7a7a")
@export var warning_color: Color = Color("#ffd166")
@export var info_color: Color = Color("#6ecbff")
@export var debug_color: Color = Color("#9aa0a6")

@export_group("Vibration")
@export var enable_vibration: bool = true

func get_log_level() -> LogLevel:
    return log_level

func get_log_color(level: LogLevel) -> String:
    match level:
        LogLevel.ERROR:
            return "#" + error_color.to_html()
        LogLevel.WARNING:
            return "#" + warning_color.to_html()
        LogLevel.INFO:
            return "#" + info_color.to_html()
        LogLevel.DEBUG:
            return "#" + debug_color.to_html()
        _:
            return ""

func get_log_level_string(level: LogLevel) -> String:
    match level:
        LogLevel.ERROR:
            return "  [ERROR]"
        LogLevel.WARNING:
            return "[WARNING]"
        LogLevel.INFO:
            return "   [INFO]"
        LogLevel.DEBUG:
            return "  [DEBUG]"
        _:
            return ""
    
func get_active_log_destinations() -> Dictionary:
    return {
        LogDestination.PRINT: log_to_print,
        LogDestination.PRINT_RICH: log_to_print_rich,
        LogDestination.LOG_FILE: log_to_text_file,
        LogDestination.HTML_FILE: log_to_html_file
    }

func get_fake_debug_messages_enabled() -> bool:
    return fake_debug_messages
