extends Node

@export var bullet_ballistic: Color
@export var bullet_ballistic_trail: Color
@export var bullet_ballistic_trail_end: Color

@export var charged_bullet_ballistic: Color
@export var charged_bullet_ballistic_trail: Color
@export var charged_bullet_ballistic_trail_end: Color

@export var bullet_ballistic_2: Color
@export var bullet_ballistic_2_trail: Color
@export var bullet_ballistic_2_trail_end: Color

@export var player: Color
@export var enemy: Color

@export var boost_start: Color
@export var boost_middle: Color
@export var boost_end: Color

enum Colors{
    NULL,
    BULLET_BALLISTIC,
    CHARGED_BULLET_BALLISTIC,
    BULLET_BALLISTIC_TRAIL,
    CHARGED_BULLET_BALLISTIC_TRAIL,
    BULLET_BALLISTIC_TRAIL_END,
    CHARGED_BULLET_BALLISTIC_TRAIL_END,
    BULLET_BALLISTIC_2,
    BULLET_BALLISTIC_2_TRAIL,
    BULLET_BALLISTIC_2_TRAIL_END,
    PLAYER,
    ENEMY,
    BOOST_START,
    BOOST_MIDDLE,
    BOOST_END
}
@onready var color_map: Dictionary = {
    Colors.NULL: null,
    Colors.BULLET_BALLISTIC: bullet_ballistic,
    Colors.CHARGED_BULLET_BALLISTIC: charged_bullet_ballistic,
    Colors.BULLET_BALLISTIC_TRAIL: bullet_ballistic_trail,
    Colors.CHARGED_BULLET_BALLISTIC_TRAIL: charged_bullet_ballistic_trail,
    Colors.BULLET_BALLISTIC_TRAIL_END: bullet_ballistic_trail_end,
    Colors.CHARGED_BULLET_BALLISTIC_TRAIL_END: charged_bullet_ballistic_trail_end,
    Colors.BULLET_BALLISTIC_2: bullet_ballistic_2,
    Colors.BULLET_BALLISTIC_2_TRAIL: bullet_ballistic_2_trail,
    Colors.BULLET_BALLISTIC_2_TRAIL_END: bullet_ballistic_2_trail_end,
    Colors.PLAYER: player,
    Colors.ENEMY: enemy,
    Colors.BOOST_START: boost_start,
    Colors.BOOST_MIDDLE: boost_middle,
    Colors.BOOST_END: boost_end
}

func get_color(color: Colors) -> Variant:
    return color_map.get(color, null)
