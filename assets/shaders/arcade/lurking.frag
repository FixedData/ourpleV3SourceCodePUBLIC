#pragma header
uniform float iTime;
uniform float AMT;//0 - 1 glitch amount
uniform float SPEED;//0 - 1 speed

//2D (returns 0 - 1)
float random2d(vec2 n){
    return fract(sin(dot(n,vec2(12.9898,4.1414)))*43758.5453);
}

float randomRange(in vec2 seed,in float min,in float max){
    return min+random2d(seed)*(max-min);
}

void main()
{
    
    float time=floor(iTime*SPEED*60.);
    vec2 uv=openfl_TextureCoordv.xy;
    
    //copy orig
    vec4 outCol=flixel_texture2D(bitmap,uv);
    
    //do slight offset on one entire channel
    float maxColOffset=AMT/6.;
    float rnd=random2d(vec2(time,9545.));
    vec2 colOffset=vec2(randomRange(vec2(time,9545.),-maxColOffset,maxColOffset),
    randomRange(vec2(time,7205.),-maxColOffset,maxColOffset));
    if(rnd<.33){
        outCol.r=flixel_texture2D(bitmap,uv+colOffset).r;
    }
    else{
        outCol.b=flixel_texture2D(bitmap,uv+colOffset).b;
    }
    
    gl_FragColor=outCol;
}