#version 460 core
#include <flutter/runtime_effect.glsl>

// Maximum blur radius. Must be a compile-time constant to satisfy SkSL loop constraints.
#define MAX_RADIUS 64
#define MAX_RADIUS_F 64.0

// Minimum sigma below which blur is negligible and skipped.
#define MIN_SIGMA 1.0e-2

// Minimum weight used to avoid division by zero during normalization.
#define MIN_WEIGHT 1.0e-5

out vec4 frag_color;

uniform vec2 u_size;
uniform sampler2D u_texture;

// Gradient map where Red channel controls [0-1] blur strength factor at given pixel.
// Where: 0 — no blur, 1 — full blur.
uniform sampler2D u_blur_texture;

// Blur sigma.
uniform float u_blur_sigma;

// An already normalized (0,1) or (1,0) direction vector.
uniform vec2 u_blur_direction;

uniform vec2 u_area_origin;
uniform vec2 u_area_size;

void main() {
  vec2 xy = FlutterFragCoord().xy;
  vec2 uv = xy / u_size;
  vec2 texel = 1.0 / u_size;

  vec2 areaXY = xy - u_area_origin;
  vec2 areaTopLeftUV = u_area_origin / u_size;
  vec2 areaBottomRightUV = (u_area_origin + u_area_size) / u_size;

#ifdef IMPELLER_TARGET_OPENGLES
  // 1. Flip the sampling UV
  uv.y = 1.0 - uv.y;

  // 2. Flip and SWAP the bounds. 
  // In GL, the 'Top' of the screen is Y=1.0, and 'Bottom' is Y=0.0.
  float tempTop = 1.0 - areaBottomRightUV.y;
  float tempBottom = 1.0 - areaTopLeftUV.y;
  
  areaTopLeftUV.y = tempTop;
  areaBottomRightUV.y = tempBottom;
#endif

  vec2 areaUV = (uv - areaTopLeftUV) / (areaBottomRightUV - areaTopLeftUV);
  areaUV = clamp(areaUV, vec2(0.0), vec2(1.0));

  vec4 bg = texture(u_texture, uv);
  float blurFactor = clamp(texture(u_blur_texture, areaUV).r, 0.0, 1.0);

  float sigma = u_blur_sigma * blurFactor;

  if (sigma < MIN_SIGMA) {
    frag_color = bg;
    return;
  }

  float invTwoSigma2 = 1.0 / (2.0 * sigma * sigma);

  // Blur radius is approximated as 3 * sigma (~99% of Gaussian contribution).
  float radius = ceil(3.0 * sigma);
  float radiusClamped = min(radius, MAX_RADIUS_F);

  vec2 texelStep = texel * u_blur_direction;

  float totalWeight = 0.0;
  vec4 totalColor = vec4(0.0);

  for (int i = 0; i <= MAX_RADIUS; i++) {
    float x = float(i);
    if (x > radiusClamped) break;
    
    float weight = exp(-(x * x) * invTwoSigma2);

    if (i == 0) {
      totalColor += bg * weight;
      totalWeight += weight;
    } else {
      vec2 offset = texelStep * x;

      vec2 uvRaw1 = uv + offset;
      vec2 uvRaw2 = uv - offset;

      // Check if inside bounds
      float mask1 =
          step(areaTopLeftUV.x, uvRaw1.x) * step(uvRaw1.x, areaBottomRightUV.x) *
          step(areaTopLeftUV.y, uvRaw1.y) * step(uvRaw1.y, areaBottomRightUV.y);

      float mask2 =
          step(areaTopLeftUV.x, uvRaw2.x) * step(uvRaw2.x, areaBottomRightUV.x) *
          step(areaTopLeftUV.y, uvRaw2.y) * step(uvRaw2.y, areaBottomRightUV.y);

      // Clamp only for safe sampling
      vec2 uv1 = clamp(uvRaw1, areaTopLeftUV, areaBottomRightUV);
      vec2 uv2 = clamp(uvRaw2, areaTopLeftUV, areaBottomRightUV);

      vec4 c1 = texture(u_texture, uv1);
      vec4 c2 = texture(u_texture, uv2);

      float w1 = weight * mask1;
      float w2 = weight * mask2;

      totalColor += c1 * w1 + c2 * w2;
      totalWeight += w1 + w2;
    }
  }

  frag_color = totalColor / max(totalWeight, MIN_WEIGHT);
}
