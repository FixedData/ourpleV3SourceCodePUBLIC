// https://www.shadertoy.com/view/XtyXzW

#pragma header

vec2 uv = openfl_TextureCoordv.xy;
uniform float time = 0.8;
uniform float prob = 0.7;
uniform float vignetteIntensity = 5;

uniform float size = .5;
uniform float grid = 6;
uniform float blocks = 0.8;

uniform float glitchScale = 0.4;

vec3 tex2D(sampler2D _tex,vec2 _p)
{
    vec3 col=flixel_texture2D(_tex,_p).xyz;
    if(.5<abs(_p.x-.5)){
        col=vec3(.1);
    }
    return col;
}

#define PI 3.14159265359
#define PHI (1.618033988749895)

// --------------------------------------------------------
// Glitch core
// --------------------------------------------------------

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 glitchCoord(vec2 p, vec2 gridSize) {
	vec2 coord = floor(p / gridSize) * gridSize;;
    coord += (gridSize / 2.);
    return coord;
}

struct GlitchSeed {
    vec2 seed;
    float prob;
};
    
float fBox2d(vec2 p, vec2 b) {
  vec2 d = abs(p) - b;
  return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

GlitchSeed glitchSeed(vec2 p, float speed) {
    float seedTime = floor(time * speed);
    vec2 seed = vec2(
        1. + mod(seedTime / 100., 100.),
        1. + mod(seedTime, 100.)
    ) / 100.;
    seed += p; 
    return GlitchSeed(seed, prob);
}

float shouldApply(GlitchSeed seed) {
    return floor(
        mix(mix(rand(seed.seed), 1., seed.prob - .5),0.,(1. - seed.prob) * .5) + 0.5
    );
}


// --------------------------------------------------------
// Glitch effects
// --------------------------------------------------------

// Swap

vec4 swapCoords(vec2 seed, vec2 groupSize, vec2 subGrid, vec2 blockSize) {
    vec2 rand2 = vec2(rand(seed), rand(seed+.1));
    vec2 range = subGrid - (blockSize - 1.);
    vec2 coord = floor(rand2 * range) / subGrid / 2;
    vec2 bottomLeft = coord * groupSize;
    vec2 realBlockSize = (groupSize / subGrid) * blockSize;
    vec2 topRight = bottomLeft + realBlockSize;
    topRight -= groupSize / 2.;
    bottomLeft -= groupSize / 2.;
    return vec4(bottomLeft, topRight);
}

float isInBlock(vec2 pos, vec4 block) {
    vec2 a = sign(pos - block.xy);
    vec2 b = sign(block.zw - pos);
    return min(sign(a.x + a.y + b.x + b.y - 3.), 0.);
}

vec2 moveDiff(vec2 pos, vec4 swapA, vec4 swapB) {
    vec2 diff = swapB.xy - swapA.xy;
	swapA.a = 1;
	swapB.a = 1;
    return diff * isInBlock(pos, swapA);
}

void swapBlocks(inout vec2 xy, vec2 groupSize, vec2 subGrid, vec2 blockSize, vec2 seed, float apply) {
    
    vec2 groupOffset = glitchCoord(xy, groupSize);
    vec2 pos = xy - groupOffset;
    
    vec2 seedA = seed * groupOffset;
    vec2 seedB = seed * (groupOffset + .1);
    
    vec4 swapA = swapCoords(seedA, groupSize, subGrid, blockSize);
    vec4 swapB = swapCoords(seedB, groupSize, subGrid, blockSize);
	swapA.a = 1;
	swapB.a = 1;
    
    vec2 newPos = pos;
    newPos += moveDiff(pos, swapA, swapB) * apply;
    newPos += moveDiff(pos, swapB, swapA) * apply;
    pos = newPos;
    
    xy = pos + groupOffset;
}


// Static


// --------------------------------------------------------
// Glitch compositions
// --------------------------------------------------------

void glitchSwap(inout vec2 p) {
    vec2 pp = p;
    
    float scale = glitchScale;
    float speed = 5.;
    
    vec2 groupSize;
    vec2 subGrid;
    vec2 blockSize;    
    GlitchSeed seed;
    float apply;
    
    groupSize = vec2(.6 + size) * scale;
    subGrid = vec2(2 + grid);
    blockSize = vec2(1 + blocks);

    seed = glitchSeed(glitchCoord(p, groupSize), speed);
    apply = shouldApply(seed);
    swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
    
    groupSize = vec2(.8 + size) * scale;
    subGrid = vec2(6 + grid);
    blockSize = vec2(2 + blocks);
    
    seed = glitchSeed(glitchCoord(p, groupSize), speed);
    apply = shouldApply(seed);
    swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);

    groupSize = vec2(.2 + size) * scale;
    subGrid = vec2(6 + grid);
    blockSize = vec2(6 + blocks);
    
    seed = glitchSeed(glitchCoord(p, groupSize), speed);
    float apply2 = shouldApply(seed);
    swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 1.), apply * apply2);
    swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 2.), apply * apply2);
    swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 3.), apply * apply2);
    swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 4.), apply * apply2);
    swapBlocks(p, groupSize, subGrid, blockSize, (seed.seed + 5.), apply * apply2);
    
    groupSize = vec2(1.2, .2) * scale;
    subGrid = vec2(9,2);
    blockSize = vec2(3,1);
    
    seed = glitchSeed(glitchCoord(p, groupSize), speed);
    apply = shouldApply(seed);
    swapBlocks(p, groupSize, subGrid, blockSize, seed.seed, apply);
}

void main() {
    // time = mod(time, 1.);
    float alpha = 1;
    vec2 p = openfl_TextureCoordv.xy;
    vec3 basecolor = texture2D(bitmap, openfl_TextureCoordv).rgb;
    
    glitchSwap(p);

    vec3 color = texture2D(bitmap, p).rgb;

    float amount = (0.5 * sin(time * PI) + vignetteIntensity);
    float vignette = 0;
	if (color == vec3(0, 0, 0))
	{
		discard;
	}
	gl_FragColor = vec4(mix(color.rgb, basecolor.rgb, vignette), flixel_texture2D(bitmap, uv).a);
}