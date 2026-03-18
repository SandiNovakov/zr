extends Object
class_name CoreConfig

### PARAMS ###
const LOG_LEVEL: LogLevel = LogLevel.DEBUG
const LOG_DESTINATION: LogDestination = LogDestination.PRINT_RICH
const ENABLE_DEBUG_DEBUG_MESSAGES: bool = false

### ENUMS / MAPS ###
enum LogLevel {
    ERROR = 0,
    WARNING = 1,
    INFO = 2,
    DEBUG = 3
}

enum LogDestination {PRINT, PRINT_RICH, FILE, VOID}

const LOG_LEVEL_MAP := {
    0: "[ERROR] ",
    1: "[WARNING] ",
    2: "[INFO] ",
    3: "[DEBUG] ",
}

const LOG_LEVEL_COLOR_MAP := {
    "[ERROR]": "#ff7a7a", # ERROR - soft red
    "[WARNING]": "#ffd166", # WARNING - yellow/orange
    "[INFO]": "#6ecbff", # INFO - light blue
    "[DEBUG]": "#9aa0a6", # DEBUG - gray
}
