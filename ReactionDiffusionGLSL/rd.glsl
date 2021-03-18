varying vec4 vertColor;
varying vec4 vertTexCoord;

// The horizontal/vertical sampling steps (for u,v), when calculating the laplacial
uniform float deltaU;
uniform float deltaV;

uniform sampler2D texture;

// Diffusion rates
const float DRATE_A = 0.9;
const float DRATE_B = 0.18;

// Rate at which Chemical A is introduced
const float FEED_RATE = 0.0545;

// Rate at which Chemical B is removed
const float KILL_RATE = 0.062;

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

    float A_1 = A + (DRATE_A * laplaceA(vertTexCoord.st, deltaU , deltaV) - A * B * B + FEED_RATE * (1 - A)) ;
    float B_1 = B + (DRATE_B * laplaceB(vertTexCoord.st, deltaU, deltaV) + A * B * B - (KILL_RATE + FEED_RATE) * B)  ;

    gl_FragColor =  vec4(A_1, B_1, 0.0, 1.0);
}