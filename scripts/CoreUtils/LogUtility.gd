extends Node

func write_log(msg: String) -> void:
    var destination: CoreConfig.LogDestination = CoreConfig.LOG_DESTINATION
    
    match destination:
        CoreConfig.LogDestination.PRINT:
            msg = Util.format_log_msg(msg, true, false)
            print(msg)
        CoreConfig.LogDestination.PRINT_RICH:
            msg = Util.format_log_msg(msg, true, true)
            print_rich(msg)
        _:
            return

func _ready() -> void:
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
