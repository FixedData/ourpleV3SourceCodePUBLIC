#pragma header

vec2 fragCoord=openfl_TextureCoordv*openfl_TextureSize; //todo kill fragcoord

uniform float glitchAmount;
uniform float iTime;

vec4 posterize(vec4 color,float numColors)
{
    return floor(color*numColors-.5)/numColors;
}

vec2 quantize(vec2 v,float steps)
{
    return floor(v*steps)/steps;
}

float dist(vec2 a,vec2 b)
{
    return sqrt(pow(b.x-a.x,2.)+pow(b.y-a.y,2.));
}

void main()
{
    vec2 uv=fragCoord.xy/openfl_TextureSize.xy;
    float amount=pow(glitchAmount,2.);
    vec2 pixel=1./openfl_TextureSize.xy;
    vec4 color=flixel_texture2D(bitmap,uv);
    float t=mod(mod(iTime,amount*100.*(amount-.5))*109.,1.);
    vec4 postColor=posterize(color,16.);
    vec4 a=posterize(flixel_texture2D(bitmap,quantize(uv,64.*t)+pixel*(postColor.rb-vec2(.5))*100.),5.).rbga;
    vec4 b=posterize(flixel_texture2D(bitmap,quantize(uv,32.-t)+pixel*(postColor.rg-vec2(.5))*1000.),4.).gbra;
    vec4 c=posterize(flixel_texture2D(bitmap,quantize(uv,16.+t)+pixel*(postColor.rg-vec2(.5))*20.),16.).bgra;
    gl_FragColor=mix(flixel_texture2D(bitmap,
            uv+amount*(quantize((a*t-b+c-(t+t/2.)/10.).rg,16.)-vec2(.5))*pixel*100.),
            (a+b+c)/3.,(.5-(dot(color,postColor)-1.5))*amount);
        }