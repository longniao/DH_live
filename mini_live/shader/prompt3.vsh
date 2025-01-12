#version 120

// Attributes (inputs)
attribute vec3 a_position;
attribute vec2 a_texture;

// Uniforms
uniform float bsVec[12];
uniform mat4 gProjection;
uniform mat4 gWorld0;
uniform sampler2D texture_bs;
uniform vec2 vertBuffer[209];

// Varyings (outputs to fragment shader)
varying vec2 v_texture;
varying vec2 v_bias;

vec4 calculateMorphPosition(vec3 position, vec2 textureCoord) {
    vec4 tmp_Position2 = vec4(position, 1.0);
    if (textureCoord.x < 3.0) {
        vec3 morphSum = vec3(0.0);
        for (int i = 0; i < 6; i++) {
            vec2 coord = vec2(textureCoord.y / 209.0, float(i) / 7.0);
            vec3 morph = texture2D(texture_bs, coord).xyz * 2.0 - 1.0;
            morphSum += bsVec[i] * morph;
        }
        vec2 coord6 = vec2(textureCoord.y / 209.0, 6.0 / 7.0);
        morphSum += bsVec[6] * texture2D(texture_bs, coord6).xyz;
        tmp_Position2.xyz += morphSum;
    }
    else if (textureCoord.x == 4.0) {
        // lower teeth
        vec3 morphSum = vec3(0.0, (bsVec[0] + bsVec[1])/ 2.7 + 6, 0.0);
        tmp_Position2.xyz += morphSum;
    }
    return tmp_Position2;
}

void main() {
    mat4 gWorld = gWorld0;
    vec4 tmp_Position2 = calculateMorphPosition(a_position, a_texture);
    vec4 tmp_Position = gWorld * tmp_Position2;

    v_bias = vec2(0.0, 0.0);
    if (a_texture.x == -1.0) {
        v_bias = vec2(0.0, 0.0);
    }
    else if (a_texture.y < 209.0) {
        vec4 vert_new = gProjection * vec4(tmp_Position.x, tmp_Position.y, tmp_Position.z, 1.0);
        v_bias = vert_new.xy - vertBuffer[int(a_texture.y)].xy;
    }

    if (a_texture.x >= 3.0) {
        gl_Position = gProjection * vec4(tmp_Position.x, tmp_Position.y, 500.0, 1.0);
    }
    else {
        gl_Position = gProjection * vec4(tmp_Position.x, tmp_Position.y, tmp_Position.z, 1.0);
    }

    v_texture = a_texture;
}