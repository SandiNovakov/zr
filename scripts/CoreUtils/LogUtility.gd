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
    var destinations: Dictionary = CoreConfig.LOG_DESTINATIONS
    
    if destinations[CoreConfig.LogDestination.LOG_FILE]:
        var file_name: String = _get_file_name_from_systime()
        log_file_ref = FileAccess.open("user://%s.txt" % [file_name], FileAccess.WRITE)
        
    if destinations[CoreConfig.LogDestination.HTML_FILE]:
        var file_name: String = _get_file_name_from_systime()
        html_file_ref = FileAccess.open("user://%s.html" % [file_name], FileAccess.WRITE)
        _write_html_header()
        
    _debug_messages()

func _write_html_header() -> void:
    if not html_file_ref:
        return
    
    html_file_ref.store_line("<!DOCTYPE html>")
    html_file_ref.store_line("<html>")
    html_file_ref.store_line("<head>")
    html_file_ref.store_line("    <meta charset='UTF-8'>")
    html_file_ref.store_line("    <style>")
    html_file_ref.store_line("        body {")
    html_file_ref.store_line("            font-family: monospace;")
    html_file_ref.store_line("            line-height: 1.4;")
    html_file_ref.store_line("            margin: 20px;")
    html_file_ref.store_line("            background-color: #1e1e1e;  /* Optional dark background */")
    html_file_ref.store_line("            color: #d4d4d4;           /* Optional light text */")
    html_file_ref.store_line("        }")
    html_file_ref.store_line("        p {")
    html_file_ref.store_line("            margin: 2px 0;")
    html_file_ref.store_line("            white-space: pre-wrap;    /* Preserve whitespace */")
    html_file_ref.store_line("            font-family: monospace;")
    html_file_ref.store_line("        }")
    html_file_ref.store_line("    </style>")
    html_file_ref.store_line("</head>")
    html_file_ref.store_line("<body>")
    html_file_ref.flush()

func _get_file_name_from_systime() -> String:
    var prefix: String = "log_"
    var time: String = Time.get_datetime_string_from_system().replace(":", "-")
    return "%s%s" % [prefix, time]

func _debug_messages() -> void:
    if CoreConfig.ENABLE_DEBUG_DEBUG_MESSAGES:
        Syslog.debug("Frame start")
        Syslog.info("Game initialized successfully")
        Syslog.warning("FPS dropped below threshold: ", 25)
        Syslog.debug("Player position: ", Vector2(123.4, 567.8))
        Syslog.error("Failed to load texture: ", "res://assets/ui.png")
        Syslog.info("Loading level: ", "Level_01")
        Syslog.debug("Velocity: ", Vector2(5, -2))
        Syslog.warning("Deprecated function used: ", "old_move()")
        Syslog.debug("Input state: ", {"left": false, "right": true})
        Syslog.error("Network timeout after ", 30, " seconds")
        Syslog.info("Player spawned at ", Vector2(100, 200))
        Syslog.debug("Collision detected with ", "Wall")
        Syslog.warning("Missing optional config: ", "user_settings.cfg")
        Syslog.debug("Delta time: ", 0.016)
        Syslog.info("Connected to server")
        Syslog.error("Could not connect to server ", "127.0.0.1")
        Syslog.debug("Updating AI for entity ", 42)
        Syslog.info("Settings loaded")
        Syslog.warning("Audio buffer underrun detected")
        Syslog.debug("Pathfinding nodes: ", 128)
        Syslog.error("Save file corrupted: slot ", 2)
        Syslog.debug("Memory usage: ", 256, " MB")
        Syslog.info("Checkpoint reached: ", 3)
        Syslog.warning("Large delta time: ", 0.45)
        Syslog.debug("Rendering batch size: ", 64)
        Syslog.error("Invalid input detected: ", "NaN")
        Syslog.info("Enemy spawned: ID=", 1024)
        Syslog.debug("Camera position: ", Vector3(0, 5, -10))
        Syslog.debug("Animation state: ", "Run")
        Syslog.warning("Value ", 42, " is approaching limit")
        Syslog.debug("Health: ", 87, "/", 100)
        Syslog.debug("Mana regen tick")
        Syslog.debug("Physics step complete")
