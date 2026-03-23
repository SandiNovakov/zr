shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float threshold = 0.7;
uniform float intensity = 1.5;
uniform float blur_size = 2.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    vec3 col = texture(screen_texture, uv).rgb;

    // Extract bright parts
    vec3 bright = max(col - vec3(threshold), vec3(0.0));

    // Simple cheap blur (4-tap)
    vec2 offset = blur_size / 1.0/SCREEN_PIXEL_SIZE;

    vec3 blur =
        texture(screen_texture, uv + vec2(offset.x, 0.0)).rgb +
        texture(screen_texture, uv - vec2(offset.x, 0.0)).rgb +
        texture(screen_texture, uv + vec2(0.0, offset.y)).rgb +
        texture(screen_texture, uv - vec2(0.0, offset.y)).rgb;

    blur *= 0.25;

    vec3 bloom = bright + blur * bright;

    vec3 final_color = col + bloom * intensity;

    COLOR = vec4(final_color, 1.0);
}