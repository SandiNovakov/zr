extends Node
class_name Spawner

@export var target_parent: Node
@export var scene: PackedScene
@export var spawn_vfx: PackedScene
@export var max_count: int = 5

@export_category("Area")
@export var min_position: Vector2
@export var max_position: Vector2

@export_category("Timing")
@export var min_interval: float = 1.0
@export var max_interval: float = 5.0

var live_count: int = 0
var timer: Timer

func _ready() -> void:
    if not target_parent:
        target_parent = GlobalRef.get_main()

    timer = Timer.new()
    timer.one_shot = true
    add_child(timer)
    timer.timeout.connect(_on_timeout)

    _start_timer()

func _start_timer() -> void:
    timer.start(randf_range(min_interval, max_interval))

func _on_timeout() -> void:
    _try_spawn()
    _start_timer()

func _try_spawn() -> void:
    if live_count >= max_count:
        return

    var spawn_position: Vector2 = Vector2(
        randf_range(min_position.x, max_position.x),
        randf_range(min_position.y, max_position.y)
    )

    var instance: Node2D = scene.instantiate()
    instance.global_position = spawn_position
    target_parent.add_child(instance)

    live_count += 1
    instance.tree_exiting.connect(func() -> void:
        live_count -= 1, CONNECT_ONE_SHOT)

    Syslog.debug("Spawner spawned %s at %s (%s/%s alive)." % [instance.name, spawn_position, live_count, max_count])

    if spawn_vfx:
        var vfx: Node2D = spawn_vfx.instantiate()
        vfx.global_position = spawn_position
        target_parent.add_child(vfx)
