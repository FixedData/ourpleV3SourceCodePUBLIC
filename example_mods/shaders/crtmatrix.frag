/* crt buffer*/

#pragma header
#extension GL_EXT_gpu_shader4 : enable
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform bool active;

precision highp int;
precision highp float;
precision highp sampler2D;

#define QUATER 0.7853981633974483
#define HALF 1.5707963267948966
#define PI 3.141592653589793
#define CIRCLE 6.283185307179586

#define REZ (iResolution.xy)

const bool shadowMask = true;
const int subScale = 6;
const float gamma = 1.25;
const float bright = 7.5;
const float blink_force = 0.0125;
const float blink_time = 1.0;
const float line = 0.25;
const float scanline = 0.2;
const float scanline_count = 25.0;
const float scanline_speed = 1.0;
const float vig = 0.175;
const float ca = 2.5;
const float lens = 0.125;
const float deep =  0.075;
const float edge = 0.0125;
const float factor = 32.0;

const mat4 table = mat4(
    -4.0, 0.0, -3.0, 1.0,
    2.0, -2.0, 3.0, -1.0,
    -3.0, 1.0, -4.0, 0.0,
    3.0, -1.0, 2.0, -2.0
);

vec2 sub;

float calcUV ( const in vec2 uv, const in float m )
{	
	float s = (0.0 + 1.0 * 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
	
	return max( m, s );

}

bool hasOutScreen ( const in vec2 uv )
{
	return uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0;

}

float udRoundBox ( const in vec2 p, const in vec2 b, const in float r )
{
	return length( max( abs( p ) - b + r, 0.0 ) ) - r;

}

bool hasOut ( vec2 fuv )
{
	return hasOutScreen( fuv ) || udRoundBox( fuv * REZ - REZ * 0.5, REZ * 0.5, min( REZ.x, REZ.y ) * edge ) > 0.0;

}

bool hasShadowMaskX ( const vec2 uv )
{
	return shadowMask && mod( uv.x * REZ.x, sub.x * 2.0 ) / sub.x > 1.0;

}

bool hasShadowMaskY ( const vec2 uv )
{
	return shadowMask && mod( uv.y * REZ.y, sub.y * 2.0 ) / sub.y > 1.0;

}

vec3 calcCRTX ( const in vec3 color, const in vec2 uv )
{
	float scan = mod(uv.x * REZ.x, sub.x) / sub.x * PI;
	float scansY = clamp( sin( scan ), 0.0, 1.0 );
	float sy = 0.5 + scansY * line * 0.5;

	return color * sy;

}

vec3 calcCRTY ( const in vec3 color, const in vec2 uv )
{   
	float scan = mod(uv.y * REZ.y, sub.y) / sub.y * PI;
	float scansX = clamp( sin( scan ), 0.0, 1.0 );
	float sx = 0.5 + scansX * line * 0.5;

	return color * sx;

}

vec3 calcScanLine ( const in vec3 color, const in vec2 uv )
{
	float scan = uv.y * scanline_count;
	float scansX = clamp( 0.35 + 0.35 * cos( scan + (iTime * scanline_speed * PI) ), 0.0, 1.0 );
	float sx = pow( scansX * scanline, 1.7 );

	return color * vec3(0.4 + 0.75 * sx);

}

vec3 fillter ( const in vec3 color, const in vec2 uv )
{
    vec3 col = color;
    
    col += table[int( uv.x ) % 4][int( uv.y ) % 4] * 0.005;  

    return floor(col * factor) / factor; 
}

vec3 getColor ( const in vec2 uv )
{
    vec2 fuv = (uv * REZ - mod( uv * REZ, sub )) / REZ;
	vec3 color = hasOut( uv ) ? vec3(0.0) : texture( iChannel0, fuv ).rgb;
	
    color = fillter( color, uv );
    
	color = pow( color, vec3(1.0 / gamma) );
	color = color + color * bright;
	
    color = calcCRTX( color, uv );
    color = calcCRTY( color, uv );
    
	return color;

}

vec2 getLensUV ( const in vec2 uv )
{
	float quat = QUATER;
	vec2 u = (uv - 0.5) * 2.0;

	vec2 par = vec2(
		(1.0 - abs( cos( u.y * quat ) )),
		(1.0 - abs( cos( u.x * quat ) ))
		
	);

	vec2 aspect = vec2(
		1.0 / (REZ.x / REZ.y),
		1.0 / (REZ.y / REZ.x)

	);

	par.x = par.x * lens + (uv.y * deep);
	par.y = par.y * (lens + par.x * uv.y * deep) + deep / 2.0;
	
	return par * aspect;
	
}

vec2 calcLensUV ( const in vec2 uv )
{
	vec2 u = (uv - 0.5) * 2.0;
	
	u *= 1.0 + getLensUV( uv );
	
	return (u / 2.0) + 0.5;
	
}

vec3 calcChromaticAberration ( const in vec2 fuv )
{
	float d = (1.0 / iResolution.x * sub.x)  / 3.0;
    
    vec2 texel = 1.0 / REZ;
    vec2 coords = (fuv - 0.5) * 2.0;
    float coordDot = dot( coords, coords );
    vec2 precompute = vec2(ca) * coordDot * coords;

    bool x = hasShadowMaskX( fuv );

    vec2 u = fuv + vec2(0.0, x ? 0.0 : 1.0 / REZ.y * sub.y / 2.0 );
    
	vec2 red = u - texel.xy * precompute;
	vec2 green = u;
	vec2 blue = u + texel.xy * precompute;
    
    vec3 o = getColor( fuv );
    
    if (!hasOut( red ))
    {
        o.r = getColor( red ).r;

    }

    if (!hasOut( green ))
    {
        o.g = getColor( green ).g;

    }

    if (!hasOut( blue ))
    {
        o.b = getColor( blue ).b;

    }
    
	return o;

}

vec3 calcBlink ( const in vec3 color, const in vec2 uv )
{
	vec3 col = color;

	col *= 1.0 + blink_force * sin( 110.0 * (iTime * blink_time) );

	return col;

}

vec3 calcVig ( const in vec3 color, const in vec2 uv )
{
	float v = (0.0 + 1.0 * 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));

	return color * vec3(pow( v, vig ));
	
}

void mainImage()
{
    vec2 uv = fragCoord.xy / REZ;
	vec2 fuv = calcLensUV( uv );

	if (active)
	{
		if (!hasOut( fuv ))
		{
			float m = 5 / iResolution.x;
			sub = max(vec2(subScale + int((m * 15.0) - mod(m * 15.0, 3.0))), REZ / openfl_TextureSize.xy);
		
			vec3 color = calcChromaticAberration( fuv );

			color = calcScanLine( color, fuv );
			color = calcBlink( color, uv );
			color = calcVig( color, fuv );
			
			fragColor = vec4(color, flixel_texture2D(bitmap, uv).a);

		}
		else
		{
			fragColor = vec4(vec3(0.0), flixel_texture2D(bitmap, uv).a);
		}
	}
	else fragColor = flixel_texture2D(bitmap, uv);
}