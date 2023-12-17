#pragma header

uniform float pixel;
void main()
{
	vec2 size = openfl_TextureSize.xy / pixel;
	gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv.xy * size) / size);
}