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


### RUNTIME VARS ###
var ENABLE_DEBUG_DEBUG_MESSAGES: bool = fake_debug_messages
var LOG_LEVEL: LogLevel = log_level


### MAPS ###
## Active log destinations
var LOG_DESTINATIONS := {
	LogDestination.PRINT: log_to_print,
	LogDestination.PRINT_RICH: log_to_print_rich,
	LogDestination.LOG_FILE: log_to_text_file,
	LogDestination.HTML_FILE: log_to_html_file
}

const LOG_LEVEL_MAP := {
	LogLevel.ERROR: "  [ERROR]",
	LogLevel.WARNING: "[WARNING]",
	LogLevel.INFO: "   [INFO]",
	LogLevel.DEBUG: "  [DEBUG]",
}

var LOG_LEVEL_COLOR_MAP := {
	LogLevel.ERROR: "#" + error_color.to_html(),
	LogLevel.WARNING: "#" + warning_color.to_html(),
	LogLevel.INFO: "#" + info_color.to_html(),
	LogLevel.DEBUG: "#" + debug_color.to_html(),
}
