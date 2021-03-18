// Implementation of reaction diffusion with 5 point stencil for Laplacian.
// TODO incomplete

varying vec2 vertTexCoord;
uniform float deltaU;
uniform float deltaV;
uniform sampler2D texture;
uniform float deltaTime;

// Diffusion rates
const float DRATE_A = 0.9;
const float DRATE_B = 0.18;

// Rate at which Chemical A is introduced
const float FEED_RATE = 0.0545;

// Rate at which Chemical B is removed
const float KILL_RATE = 0.062;

void main()
{
    // If enabled, the following gives a "parameter map" view
    //float feed = vertTexCoord.y * 0.083; float kill = vertTexCoord.x * 0.073;

    // Generate 5-point stencil sampling coordinates with wraparound
    float xm1 = vertTexCoord.x - deltaU;
    float xp1 = vertTexCoord.x + deltaU;
    float ym1 = vertTexCoord.y - deltaV;
    float yp1 = vertTexCoord.y + deltaV;
    xm1 = (xm1 < 0.0) ? xm1 + 1.0 : xm1;
    xp1 = (xp1 > 1.0) ? xp1 - 1.0 : xp1;
    ym1 = (ym1 < 0.0) ? ym1 + 1.0 : ym1;
    yp1 = (yp1 > 1.0) ? yp1 - 1.0 : yp1;

    // Sample texture with 5-point stencil
    vec2 uv = texture2D(texture, vertTexCoord).rg;
    vec2 uv0 = texture2D(texture, vec2(xm1, vertTexCoord.y)).rg;
    vec2 uv1 = texture2D(texture, vec2(xp1, vertTexCoord.y)).rg;
    vec2 uv2 = texture2D(texture, vec2(vertTexCoord.x, ym1)).rg;
    vec2 uv3 = texture2D(texture, vec2(vertTexCoord.x, yp1)).rg;
    
    vec2 lapl = (uv0 + uv1 + uv2 + uv3 - 4.0 * uv);//10485.76;
    float du = /*0.00002*/
                        0.2097 * lapl.r - uv.r * uv.g * uv.g + FEED_RATE * (1.0 - uv.r);
    float dv = /*0.00001*/
                        0.105 * lapl.g + uv.r * uv.g * uv.g - (FEED_RATE + KILL_RATE) * uv.g;

    vec2 dst = uv + deltaTime * vec2(du, dv);
    
    gl_FragColor = vec4(dst.r, dst.g, 0.0, 1.0);
}