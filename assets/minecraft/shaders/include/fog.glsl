#version 150
#moj_import <fogconfig.glsl>

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    if (vertexDistance <= fogStart) {return inColor;}
    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;

    float fogRColor = ceil(fogColor.r * 255);
    float fogGColor = ceil(fogColor.g * 255);
    float fogBColor = ceil(fogColor.b * 255);
    if (REDUCE_LAVA_FOG               && fogRColor == 153 && fogGColor == 26  && fogBColor == 0)   {fogColor.a *= 0.5;}
    if (REDUCE_POWDER_SNOW_FOG        && fogRColor == 159 && fogGColor == 188 && fogBColor == 201) {fogColor.a *= 0.5;}
    if (REDUCE_BLINDNESS_DARKNESS_FOG && fogRColor == 0   && fogGColor == 0   && fogBColor == 0)   {fogColor.a *= 0.5;}
    if (REDUCE_END_FOG                && fogRColor == 21  && fogGColor == 17  && fogBColor == 21)  {fogColor.a *= 0.5;}

    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float linear_fog_fade(float vertexDistance, float fogStart, float fogEnd) {
    if (vertexDistance <= fogStart) {return 1.0;}
    else if (vertexDistance >= fogEnd) {return 0.0;}
    return smoothstep(fogEnd, fogStart, vertexDistance);
}

float fog_distance(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {return length((modelViewMat * vec4(pos, 1.0)).xyz);}
    else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}