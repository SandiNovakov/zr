extends Node
## Autoload. Writes lines formatted by Syslog to stdout, and to a .txt file
## under user:// when LOG_TO_FILE is true.

const LOG_TO_FILE: bool = true

var log_file_ref: FileAccess

func _ready() -> void:
    if LOG_TO_FILE:
        var file_name: String = _get_file_name_from_systime()
        log_file_ref = FileAccess.open("user://%s.txt" % [file_name], FileAccess.WRITE)

func write_log(p_colored_msg: String, p_plain_msg: String) -> void:
    print_rich(p_colored_msg)

    if LOG_TO_FILE and log_file_ref:
        log_file_ref.store_line(p_plain_msg)
        log_file_ref.flush()

func _get_file_name_from_systime() -> String:
    var prefix: String = "log_"
    var time: String = Time.get_datetime_string_from_system().replace(":", "-")
    return "%s%s" % [prefix, time]
