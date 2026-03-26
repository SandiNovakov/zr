extends Node

@export var min_interval: float = 0.02
@export var max_interval: float = 0.5

var _rng := RandomNumberGenerator.new()
var _timer: Timer

func _ready() -> void:
    if not CoreConfig.get_fake_debug_messages_enabled():
        queue_free()
    else:
        _rng.randomize()

        _timer = Timer.new()
        _timer.one_shot = true
        add_child(_timer)
        _timer.timeout.connect(_on_timeout)

        _start_timer()


func _start_timer() -> void:
    _timer.start(_rng.randf_range(min_interval, max_interval))


func _on_timeout() -> void:
    _emit_random()
    _start_timer()

func _emit_random() -> void:
    match _rng.randi_range(0, 32):
        0:
            Syslog.debug("Frame start")
        1:
            Syslog.info("Game initialized successfully")
        2:
            Syslog.warning("FPS dropped below threshold: ", _rng.randi_range(15, 40))
        3:
            Syslog.debug("Player position: ", Vector2(_rf(), _rf()))
        4:
            Syslog.error("Failed to load texture: ", "res://assets/ui.png")
        5:
            Syslog.info("Loading level: ", "Level_", _rng.randi_range(1, 5))
        6:
            Syslog.debug("Velocity: ", Vector2(_rf(-10, 10), _rf(-10, 10)))
        7:
            Syslog.warning("Deprecated function used: ", "old_move()")
        8:
            Syslog.debug("Input state: ", {"left": _rb(), "right": _rb()})
        9:
            Syslog.error("Network timeout after ", _rng.randi_range(5, 60), " seconds")
        10:
            Syslog.info("Player spawned at ", Vector2(_rf(), _rf()))
        11:
            Syslog.debug("Collision detected with ", "Wall")
        12:
            Syslog.warning("Missing optional config: ", "user_settings.cfg")
        13:
            Syslog.debug("Delta time: ", _rf(0.01, 0.05))
        14:
            Syslog.info("Connected to server")
        15:
            Syslog.error("Could not connect to server ", "127.0.0.1")
        16:
            Syslog.debug("Updating AI for entity ", _rng.randi_range(1, 100))
        17:
            Syslog.info("Settings loaded")
        18:
            Syslog.warning("Audio buffer underrun detected")
        19:
            Syslog.debug("Pathfinding nodes: ", _rng.randi_range(50, 500))
        20:
            Syslog.error("Save file corrupted: slot ", _rng.randi_range(1, 3))
        21:
            Syslog.debug("Memory usage: ", _rng.randi_range(100, 1024), " MB")
        22:
            Syslog.info("Checkpoint reached: ", _rng.randi_range(1, 10))
        23:
            Syslog.warning("Large delta time: ", _rf(0.2, 1.0))
        24:
            Syslog.debug("Rendering batch size: ", _rng.randi_range(16, 256))
        25:
            Syslog.error("Invalid input detected: ", "NaN")
        26:
            Syslog.info("Enemy spawned: ID=", _rng.randi_range(1000, 5000))
        27:
            Syslog.debug("Camera position: ", Vector3(_rf(), _rf(), _rf()))
        28:
            Syslog.debug("Animation state: ", "Run")
        29:
            Syslog.warning("Value ", _rng.randi_range(30, 50), " is approaching limit")
        30:
            Syslog.debug("Health: ", _rng.randi_range(0, 100), "/", 100)
        31:
            Syslog.debug("Mana regen tick")
        32:
            Syslog.debug("Physics step complete")


func _rf(min_val: float = 0.0, max_val: float = 1000.0) -> float:
    return _rng.randf_range(min_val, max_val)


func _rb() -> bool:
    return _rng.randi() % 2 == 0
