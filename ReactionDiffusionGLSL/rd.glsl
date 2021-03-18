varying vec4 vertColor;
varying vec4 vertTexCoord;

// The horizontal/vertical sampling steps (for u,v), when calculating the laplacial
uniform float deltaU;
uniform float deltaV;

uniform sampler2D texture;

// Currently unused
uniform float deltaTime; // milliseconds

const float STEP_MULTIPLIER = 1;

// Diffusion rates
uniform float dRateA = 0.9;
uniform float dRateB = 0.18;

// Rate at which Chemical A is introduced
uniform float feedRate = 0.0945;

// Rate at which Chemical B is removed
uniform float killRate = 0.09;

// Weights for Laplacian
const float CORNER_WEIGHT = 0.05;
const float ADJACENT_WEIGHT = 0.2;
const float CENTER_WEIGHT = 1.0;

// Laplace is a weighted sum of the neighbors minus center
// This influences diffusion.
float laplaceA(in vec2 p, in float deltaU, in float deltaV){
    float A = 
        CORNER_WEIGHT * texture2D(texture, vertTexCoord.st+ vec2(-deltaU,-deltaV))[0]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,- deltaV))[0]
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st  + vec2(deltaU,-deltaV))[0]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(-deltaU,0))[0]
        - CENTER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,0))[0]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(deltaU, 0))[0]
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(-deltaU,deltaV))[0]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,deltaV))[0]
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(deltaU,deltaV))[0];

    return A;
}

float laplaceB(in vec2 p, in float deltaU, in float deltaV){
    float B = 
        CORNER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(-deltaU,-deltaV))[1]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,- deltaV))[1]
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st  + vec2(deltaU,-deltaV))[1]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(-deltaU,0))[1]
        - CENTER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,0))[1]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(deltaU, 0))[1] 
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(-deltaU,deltaV))[1]
        + ADJACENT_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(0,deltaV))[1]
        + CORNER_WEIGHT * texture2D(texture, vertTexCoord.st + vec2(deltaU,deltaV))[1];
    return B;
}
void main(){
    float A = texture2D(texture, vertTexCoord.st )[0] ;
    float B = texture2D(texture, vertTexCoord.st )[1] ;

    float A_1 = A + STEP_MULTIPLIER * (dRateA * laplaceA(vertTexCoord.st, deltaU , deltaV) - A * B * B + feedRate * (1 - A)) ;
    float B_1 = B + STEP_MULTIPLIER * (dRateB * laplaceB(vertTexCoord.st, deltaU, deltaV) + A * B * B - (killRate + feedRate) * B)  ;

    gl_FragColor =  vec4(A_1, B_1, 0.0, 1.0);
}