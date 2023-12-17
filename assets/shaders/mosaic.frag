#pragma header
uniform float pixelsize=1;
void main(){
    vec2 size=openfl_TextureSize.xy/pixelsize;
    gl_FragColor=flixel_texture2D(bitmap,floor(openfl_TextureCoordv.xy*size)/size);
}