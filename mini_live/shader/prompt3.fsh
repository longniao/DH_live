#version 120

varying vec2 v_texture;
varying vec2 v_bias;

void main() {
    float alpha = 1.0;
    if (v_texture.x == -1.0) {
        alpha = 0.0;
    }
    else if (v_texture.x < 3.0) {
        float bias_len = length(v_bias);
        alpha = clamp(1.0 - bias_len * 2.0, 0.0, 1.0);
    }
    gl_FragColor = vec4(0.0, 0.0, 0.0, alpha);
}