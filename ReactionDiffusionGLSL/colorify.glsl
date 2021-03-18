// References: http://www.kimri.org/blog/?p=847, https://www.shadertoy.com/view/4dcGW2

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;

void main(){
    float A = texture2D(texture, vertTexCoord.st )[0] ;
    float B = texture2D(texture, vertTexCoord.st )[1] ;

    // TODO fancy coloring effects, gradient-based lighting, post processing

    // Stylized blue
    gl_FragColor = vec4(A * 0.4, B, 0.5 + 0.5 * B, 1.0);

    // Black and white
    // gl_FragColor =  vec4(B, B, B, 1.0);

    // Raw
    // float C = texture2D(texture, vertTexCoord.st )[2] ;
    // gl_FragColor =  vec4(A, B, C, 1.0);
}