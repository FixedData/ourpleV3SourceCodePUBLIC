	#pragma header
	//https://www.shadertoy.com/view/XldBRM
	
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	uniform float iTime;

	#define DOT 0.4 //for larger spacing + smaller dots, decrease value below 0.4
	#define RECT 0.5

	const float pixSizeX = 6.0; //width of LED in pixel
	const float pixSizeY = 6.0; //height of LED in pixel
	vec3 dmdColor = vec3(0.9, 0.0, 0.0); //specify color of Dotmatrix LED
	float pixThreshold = 0.45; //specify at what threshold a pixel will become either on or off
	bool flickering = true;//do you want flickering enabled? emulates line wise updating of LEDs, 0.0 = disabled, 1.0 = enable
	float dotOrRect = DOT; //DOT or RECT - LEDs in round or rectangular shape

	void main()
	{
		//indexing shenanigans needed for color averaging
		float indexX = fragCoord.x - .5;
		float indexY = fragCoord.y - .5;
		float cellX = floor(indexX / pixSizeX)* pixSizeX;
		float cellY = floor(indexY / pixSizeY)* pixSizeY;
		
		//handle mouse input, slide between greyscale and binary pixels
		float binary = 0.0f;
		// if(indexX < iMouse.x)
		// 	binary = 1.0f;

		float texAvg = 0.0;
		//fast version of above nested loop
		vec2 currUV = vec2(cellX/openfl_TextureSize.x, cellY/openfl_TextureSize.y);
		vec4 currTexVal = flixel_texture2D(bitmap, currUV); 
		texAvg = 0.3*currTexVal.r + 0.59*currTexVal.g + 0.11*currTexVal.b;
		
		//switch pixels on/off
		texAvg = (1.0f-binary)*texAvg + binary*step(pixThreshold, texAvg);
		
		//colorize in dmd color
		vec4 col = currTexVal;
		
		//Apply black parts of matrix
		vec2 uvDots = vec2(fract(indexX / pixSizeX), fract(indexY / pixSizeY));
		float circle = 1. - step(dotOrRect, length(uvDots - .5));
		col = col * circle;
		
		//flickering        
		float f = 0.0;
		if(flickering && length(col) > 0.0)
			f = sin(cellY - iTime * 20.)*0.05;
		col.r = col.r + f;
		col.g = col.g + f;
		col.b = col.b + f;
		// Output to screen
		gl_FragColor = col;   
	}


