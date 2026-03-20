extends Object
class_name CoreConfig

### PARAMS ###
const LOG_LEVEL: LogLevel = LogLevel.DEBUG
const ENABLE_DEBUG_DEBUG_MESSAGES: bool = false

## Active log destinations
const LOG_DESTINATIONS := {
    LogDestination.PRINT: false,
    LogDestination.PRINT_RICH: true,
    LogDestination.LOG_FILE: false,
    LogDestination.HTML_FILE: true
}

### ENUMS / MAPS ###
enum LogLevel {
    ERROR = 0,
    WARNING = 1,
    INFO = 2,
    DEBUG = 3
}

const LOG_LEVEL_MAP := {
    LogLevel.ERROR: "  [ERROR]",
    LogLevel.WARNING: "[WARNING]",
    LogLevel.INFO: "   [INFO]",
    LogLevel.DEBUG: "  [DEBUG]",
}

const LOG_LEVEL_COLOR_MAP := {
    LogLevel.ERROR: "#ff7a7a", # ERROR - soft red
    LogLevel.WARNING: "#ffd166", # WARNING - yellow/orange
    LogLevel.INFO: "#6ecbff", # INFO - light blue
    LogLevel.DEBUG: "#9aa0a6", # DEBUG - gray
}

enum LogDestination {PRINT, PRINT_RICH, LOG_FILE, HTML_FILE}
