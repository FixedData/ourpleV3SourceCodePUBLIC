#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform float power;
uniform float chromo;

void mainImage()
{
    // uv (0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // uv (-1 to 1, 0 - center)
    uv.x = 2. * uv.x - 1.;
    uv.y = 2. * uv.y - 1.;
    
    float barrel_power = power; // increase for BIGGER EYE!
    float theta = atan(uv.y, uv.x);
	float radius = length(uv);
	radius = pow(radius, barrel_power);
	uv.x = radius * cos(theta);
	uv.y = radius * sin(theta);
    
    // uv (0 to 1)
    uv.x = 0.5 * (uv.x + 1.);
    uv.y = 0.5 * (uv.y + 1.);

    float chromo_x = chromo;
    float chromo_y = chromo;
    
    // output
    fragColor = vec4(texture(iChannel0, vec2(uv.x - chromo_x*0.016, uv.y - chromo_y*0.009)).r, texture(iChannel0, vec2(uv.x + chromo_x*0.0125, uv.y - chromo_y*0.004)).g, texture(iChannel0, vec2(uv.x - chromo_x*0.0045, uv.y + chromo_y*0.0085)).b, 1.0);;
}