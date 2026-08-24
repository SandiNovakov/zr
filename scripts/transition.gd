extends Object
class_name Transition
# --- Add these consts near the top of Util.gd ---

const TRANSITION_DURATION: float = 0.1
const TRANSITION_MAX_PROGRESS: float = 1.1 # covers screen corners at any aspect ratio

const TRANSITION_SHADER_CODE: String = """
shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.5) = 0.0;
uniform vec4 fill_color : source_color = vec4(0.03, 0.03, 0.1, 1.0);
uniform vec4 edge_color : source_color = vec4(0.4, 0.85, 1.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.2) = 0.05;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	
	// correct for aspect ratio so the wipe is a circle, not an ellipse
	float aspect = (1.0 / SCREEN_PIXEL_SIZE.x) / (1.0 / SCREEN_PIXEL_SIZE.y);
	uv.x *= aspect;
	
	float dist = length(uv);
	
	float fill_mask = 1.0 - smoothstep(progress, progress + edge_width, dist);
	float ring = smoothstep(progress - edge_width, progress, dist) - smoothstep(progress, progress + edge_width, dist);
	
	COLOR = vec4(mix(fill_color.rgb, edge_color.rgb, ring), fill_mask);
}
"""


# --- Replace the existing change_scene with this ---

static func change_scene(path: String) -> void:
    var root: Node = GlobalRef.get_root()
    var tree: SceneTree = root.get_tree()
    var overlay: ColorRect = _make_transition_overlay()
    root.add_child(overlay)
    
    var material: ShaderMaterial = overlay.material
    
    var tween_in: Tween = tree.create_tween()
    tween_in.tween_method(
        func(v: float) -> void: material.set_shader_parameter("progress", v),
        0.0, TRANSITION_MAX_PROGRESS, TRANSITION_DURATION
    ).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    await tween_in.finished
    
    for child in root.get_children():
        if child != overlay:
            child.queue_free()
    root.add_child(load(path).instantiate())
    root.move_child(overlay, -1) # keep overlay drawn above the new scene
    
    var tween_out: Tween = tree.create_tween()
    tween_out.tween_method(
        func(v: float) -> void: material.set_shader_parameter("progress", v),
        TRANSITION_MAX_PROGRESS, 0.0, TRANSITION_DURATION
    ).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    await tween_out.finished
    
    overlay.queue_free()


static func _make_transition_overlay() -> ColorRect:
    var shader: Shader = Shader.new()
    shader.code = TRANSITION_SHADER_CODE
    
    var material: ShaderMaterial = ShaderMaterial.new()
    material.shader = shader
    material.set_shader_parameter("progress", 0.0)
    
    var overlay: ColorRect = ColorRect.new()
    overlay.material = material
    overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    overlay.z_index = 4096
    
    return overlay
