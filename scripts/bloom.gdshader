shader_type canvas_item;

// Bloom settings
uniform float intensity : hint_range(0.0, 2.0) = 0.5;
uniform float radius : hint_range(0.0, 10.0) = 2.0;
uniform float threshold : hint_range(0.0, 1.0) = 0.1;

// Bloom pyramid textures
uniform sampler2D bloom_texture_0 : source_color;
uniform sampler2D bloom_texture_1 : source_color;
uniform sampler2D bloom_texture_2 : source_color;
uniform sampler2D bloom_texture_3 : source_color;

vec4 sample_bloom_pyramid(vec2 uv, float lod) {
    if (lod < 0.5) return texture(bloom_texture_0, uv);
    if (lod < 1.5) return texture(bloom_texture_1, uv);
    if (lod < 2.5) return texture(bloom_texture_2, uv);
    return texture(bloom_texture_3, uv);
}

void compositor() {
    vec4 color = texture(SOURCE, UV);
    
    // Extract bright parts
    float brightness = max(color.r, max(color.g, color.b));
    float contribution = max(0.0, brightness - threshold);
    vec4 bright = color * contribution / max(brightness, 0.001);
    
    // Sample bloom pyramid at different scales
    vec4 bloom = vec4(0.0);
    float total_weight = 0.0;
    
    for (float i = 0.0; i <= 3.0; i++) {
        float weight = exp(-i * i * 0.5);
        total_weight += weight;
        bloom += sample_bloom_pyramid(UV, i) * weight;
    }
    bloom /= total_weight;
    
    // Combine original with bloom
    color += bloom * intensity;
    
    // Apply tone mapping (optional - prevents overexposure)
    color = color / (color + vec4(1.0));
    
    RESULT = color;
}