package shaders;
import flixel.system.FlxAssets.FlxShader;

class ChromaticAbb extends FlxShader
{   //should simplify this later
	//k i made it simple
	//i made it even more simple
	@:isVar
	public var strength(get,set):Float = 0.0;
	function get_strength()
	{
		return (amount.value[0]);
	}
		
	function set_strength(v:Float)
	{
		amount.value = [v, v];
		return v;
	}

	@:glFragmentSource('
		#pragma header

		uniform float amount; //the point of this amount shit is so u dont have to put like a super tiny decimal to get it to look right
		float offset = 0.01 * amount;
		
		void main()
		{
			vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
			col.r = flixel_texture2D(bitmap, openfl_TextureCoordv.st - vec2(-offset, 0.0)).r;
			col.b = flixel_texture2D(bitmap, openfl_TextureCoordv.st - vec2(offset, 0.0)).b;

			gl_FragColor = col;
		}
	')
	public function new()
	{
		super();
		this.amount.value = [0,0];
	}
}