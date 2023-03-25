// FRAGMENT SHADER
// This is a simple "dissolve" fragment shader with "standard" uniforms to
// demonstrate ShaderEffect.

#version 460 core
#include <flutter/runtime_effect.glsl>

precision lowp float;
out vec4 oColor;

// these are the uniforms set by `ShaderUpdateDetails.updateUniforms` and also
// set by default if you don't specify an `update` handler for `ShaderEffect`:
uniform vec2 size;
uniform float value;
uniform sampler2D image;

// this is a very basic hash function, to get pseudo-random values:
float rand(vec2 co){
  return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / size;
  vec4 px = texture(image, uv);
  
  float a = rand(uv) * 0.99 + 0.01 > value ? 0 : 1;
  
  oColor = px * a;
}