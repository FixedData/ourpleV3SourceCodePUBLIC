	#pragma header
	
	//const float AMT = 0.3;
	uniform float AMT;
	uniform float SPEED;
	//const float SPEED = 32.;
	uniform float iTime;
	
	float random2d(vec2 n){
		return fract(sin(dot(n,vec2(12.9898,4.1414)))*43758.5453);
	}
	
	float randomRange(in vec2 seed,in float min,in float max){
		return min+random2d(seed)*(max-min);
	}
	
	float insideRange(float v,float bottom,float top){
		return step(bottom,v)-step(top,v);
	}
	
	void main()
	{
		vec4 outCol=flixel_texture2D(bitmap,openfl_TextureCoordv.xy);
		
		float maxOffset=AMT/32.;
		for(float i=0.;i<10.*AMT;i+=.25){
			float thingy = i;
			float sliceY=random2d(vec2(floor(iTime*SPEED),2345.+thingy));
			float sliceH=random2d(vec2(floor(iTime*SPEED),925.+thingy))*.075;
			float hOffset=randomRange(vec2(floor(iTime*SPEED),25.+thingy),-maxOffset,maxOffset);
			vec2 uvOff=openfl_TextureCoordv.xy;
			uvOff.x+=hOffset;
			if(insideRange(openfl_TextureCoordv.y,sliceY,fract(sliceY+sliceH))==1.){
				outCol=flixel_texture2D(bitmap,uvOff);
			}
		}
		
		gl_FragColor=outCol;
	}