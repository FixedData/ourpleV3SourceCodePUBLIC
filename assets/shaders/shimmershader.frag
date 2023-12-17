
#pragma header
vec2 uv=openfl_TextureCoordv.xy;
vec2 fragCoord=openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution=openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
	vec2 uv = fragCoord.xy / iResolution.xy;

    float speed = 0.58;
    float linewidth = 0.58;
    float grad = 3.0;
    vec4 col1 = vec4(0.3,0.0,0.0,1.0);
    vec4 col2 = vec4(0.85,0.85,0.85,1.0);
        
    // Sample texture...
    vec4 t1 = texture(iChannel0, uv);

    // Plot line...
    vec2 linepos = uv;
    linepos.x = linepos.x - mod(iTime*speed,2.0)+0.5;

    float y = linepos.x*grad;
	float s = smoothstep( y-linewidth, y, linepos.y) - smoothstep( y, y+linewidth, linepos.y); 
    
    // Merge texture + Glint
	fragColor = t1 + ((s));
}

