class_name CollisionLibrary
extends RefCounted

# =========================================================
# LAYERS
# =========================================================
enum Layer {
    WORLD = 1,
    ALLY = 2,
    BULLET = 3,
    ENEMY = 4,
    ENTITY = 5
}


# =========================================================
# PRESET CLASS
# =========================================================
class Preset:
    extends RefCounted

    var collision_layer: int = 0
    var collision_mask: int = 0
    
    func _init(layer: int, mask: int) -> void:
        collision_layer = layer
        collision_mask = mask

# =========================================================
# HELPERS
# =========================================================
static func bit(layer: int) -> int:
        return 1 << (layer - 1)

static func bits(layers: Array[int]) -> int:
    var value: int = 0

    for layer: int in layers:
        value |= bit(layer)

    return value

# =========================================================
# PRESET COLLECTION
# Use: CollisionLibrary.Presets.PLAYER
# =========================================================
var world: Preset = Preset.new(
    bit(Layer.WORLD),
    bit(Layer.ENTITY)
)

var actor_collision_box: Preset = Preset.new(
    bit(Layer.ENTITY),
    bits([
        Layer.WORLD,
        Layer.ENTITY
    ])
)

var ally_bullet: Preset = Preset.new(
    bit(Layer.BULLET),
    bits([
        Layer.WORLD,
        Layer.ENEMY
    ])
)

var enemy_bullet: Preset = Preset.new(
    bit(Layer.BULLET),
    bits([
        Layer.WORLD,
        Layer.ALLY
    ])
)

var ally_hitbox: Preset = Preset.new(
    bit(Layer.ALLY),
    bit(Layer.BULLET)
)

var enemy_hitbox: Preset = Preset.new(
    bit(Layer.ENEMY),
    bit(Layer.BULLET)
)

# =========================================================
# USER-FACING API
# Use: CollisionLibrary.set_collisions(self, CollisionLibrary.Presets.PLAYER)
# =========================================================
static func set_collisions(body: CollisionObject2D, preset: Preset) -> void:
    body.collision_layer = preset.collision_layer
    body.collision_mask = preset.collision_mask
