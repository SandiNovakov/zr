extends Node
class_name ScoreDisplay

const SCORE_DIGITS: int = 12
const LEADING_ZERO_COLOR: String = "#ffffff80"

@export var score_label: RichTextLabel
@export var high_score_label: RichTextLabel
@export var new_best_label: Control

@export_category("Score Count-Up")
@export var count_duration: float = 1.5
@export var count_trans: Tween.TransitionType = Tween.TRANS_CUBIC
@export var count_ease: Tween.EaseType = Tween.EASE_OUT

@export_category("New Best Popup")
@export var new_best_duration: float = 0.4

func _ready() -> void:
    new_best_label.visible = false
    new_best_label.scale = Vector2.ZERO

    _set_score_text(0.0, score_label)
    _set_score_text(float(Settings.get_high_score()), high_score_label)

    var achieved_score: int = Settings.last_score

    var tween: Tween = create_tween()
    tween.set_trans(count_trans)
    tween.set_ease(count_ease)
    tween.tween_method(_set_score_text.bind(score_label), 0.0, float(achieved_score), count_duration)

    await tween.finished

    _reveal_high_score(achieved_score)

func _set_score_text(p_value: float, p_label: RichTextLabel) -> void:
    var displayed: int = int(round(p_value))
    var score_text: String = str(displayed).lpad(SCORE_DIGITS, "0")
    var zero_count: int = SCORE_DIGITS - str(displayed).length()

    p_label.text = "[color=%s]%s[/color]%s" % [
        LEADING_ZERO_COLOR,
        score_text.left(zero_count),
        score_text.substr(zero_count)
    ]

func _reveal_high_score(p_achieved_score: int) -> void:
    var old_high_score: int = Settings.get_high_score()
    var is_new_best: bool = p_achieved_score > old_high_score

    Settings.save_high_score(p_achieved_score)

    if is_new_best:
        var tween: Tween = create_tween()
        tween.set_trans(count_trans)
        tween.set_ease(count_ease)
        tween.tween_method(_set_score_text.bind(high_score_label), float(old_high_score), float(p_achieved_score), count_duration)

        _show_new_best()

func _show_new_best() -> void:
    new_best_label.visible = true

    var tween: Tween = create_tween()
    tween.set_trans(Tween.TRANS_BOUNCE)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(new_best_label, "scale", Vector2.ONE, new_best_duration)
