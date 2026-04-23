class_name CollisionLibrary
extends RefCounted


# =========================================================
# LAYERS
# =========================================================

enum Layer {
    WORLD = 1,
    PLAYER = 2,
    ALLY_BULLET = 3,
    ENEMY = 4,
    ENEMY_BULLET = 5,
    ENTITY = 6
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
    bits([
        Layer.PLAYER,
        Layer.ENEMY,
        Layer.ENTITY
    ])
)

var player: Preset = Preset.new(
    bit(Layer.PLAYER),
    bits([
        Layer.WORLD,
        Layer.ENEMY,
        Layer.ENEMY_BULLET,
        Layer.ENTITY
    ])
)

var ally: Preset = Preset.new(
    bit(Layer.ALLY_BULLET),
    bits([
        Layer.WORLD,
        Layer.ENEMY
    ])
)

var enemy: Preset = Preset.new(
    bit(Layer.ENEMY),
    bits([
        Layer.WORLD,
        Layer.PLAYER,
        Layer.ALLY_BULLET,
        Layer.ENTITY
    ])
)

var enemy_bullet: Preset = Preset.new(
    bit(Layer.ENEMY_BULLET),
    bits([
        Layer.WORLD,
        Layer.PLAYER
    ])
)

var entity: Preset = Preset.new(
    bit(Layer.ENTITY),
    bits([
        Layer.WORLD,
        Layer.PLAYER,
        Layer.ENEMY
    ])
)


# =========================================================
# USER-FACING API
# Use: CollisionLibrary.set_collisions(self, CollisionLibrary.Presets.PLAYER)
# =========================================================

static func set_collisions(body: CollisionObject2D, preset: Preset) -> void:
    body.collision_layer = preset.collision_layer
    body.collision_mask = preset.collision_mask
