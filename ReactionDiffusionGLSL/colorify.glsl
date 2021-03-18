// References: http://www.kimri.org/blog/?p=847, https://www.shadertoy.com/view/4dcGW2

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float screenH;

uniform sampler2D texture;

vec3 draw_line(float d, float thickness) {
  const float aa = 3.0;
  return vec3(smoothstep(0.0, aa / screenH, max(0.0, abs(d) - thickness)));
}

vec3 draw_line(float d) {
  return draw_line(d, 0.0025);
}

float draw_solid(float d) {
  return smoothstep(0.0, 3.0 / screenH, max(0.0, d));
}

vec4 grayToBands(float d) {
  float t = clamp(d * 0.85, d * 0.85, 1.0);
  vec3 grad = mix(vec3(1.0, 0.8, 1.0), vec3(0.3, 0.6, 1), t);

  float d0 = abs(1.0 - draw_line(mod(d + 0.1, 0.2) - 0.1).x);
  float d1 = abs(1.0 - draw_line(mod(d + 0.025, 0.05) - 0.025).x);
  float d2 = abs(1.0 - draw_line(d).x);
  vec3 rim = vec3(max(d2 * 0.85, max(d0 * 0.25, d1 * 0.06125)));

  grad -= rim;
  grad -= mix(vec3(0.05, 0.35, 0.35), vec3(0.0), draw_solid(d));

  return vec4(grad, 1.0);
}

void main(){
    float A = texture2D(texture, vertTexCoord.st )[0] ;
    float B = texture2D(texture, vertTexCoord.st )[1] ;

    // TODO fancy coloring effects, gradient-based lighting, post processing

    // Bands
    gl_FragColor = grayToBands(B);

    // Stylized blue
    //gl_FragColor = vec4(A * 0.4, B, 0.5 + 0.5 * B, 1.0);

    // Black and white
    // gl_FragColor =  vec4(B, B, B, 1.0);

    // Raw
    // float C = texture2D(texture, vertTexCoord.st )[2] ;
    // gl_FragColor =  vec4(A, B, C, 1.0);
}