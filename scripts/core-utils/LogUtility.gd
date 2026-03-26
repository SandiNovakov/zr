extends Node

var html_file_ref: FileAccess
var log_file_ref: FileAccess

func write_log(msg: String, destination: CoreConfig.LogDestination) -> void:
    match destination:
        CoreConfig.LogDestination.PRINT:
            print(msg)
        
        CoreConfig.LogDestination.PRINT_RICH:
            print_rich(msg)
        
        CoreConfig.LogDestination.LOG_FILE:
            if log_file_ref:
                log_file_ref.store_line(msg)
                log_file_ref.flush()
            
        CoreConfig.LogDestination.HTML_FILE:
            if html_file_ref:            
                html_file_ref.store_line(msg)
                html_file_ref.flush()

func _ready() -> void: 
    var destinations: Dictionary = CoreConfig.get_active_log_destinations()
    
    if destinations[CoreConfig.LogDestination.LOG_FILE]:
        var file_name: String = _get_file_name_from_systime()
        log_file_ref = FileAccess.open("user://%s.txt" % [file_name], FileAccess.WRITE)
        
    if destinations[CoreConfig.LogDestination.HTML_FILE]:
        var file_name: String = _get_file_name_from_systime()
        html_file_ref = FileAccess.open("user://%s.html" % [file_name], FileAccess.WRITE)
        HtmlUtil.write_html_header(html_file_ref)

func _get_file_name_from_systime() -> String:
    var prefix: String = "log_"
    var time: String = Time.get_datetime_string_from_system().replace(":", "-")
    return "%s%s" % [prefix, time]
