    #pragma header

    uniform float iTime;
    uniform sampler2D noiseTex;

    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
      	vec4 video = flixel_texture2D(bitmap,look);
      	return video;
      }

    float scanline(vec2 uv) {
        return sin(openfl_TextureSize.y * uv.y * 0.7 - iTime * 10.0);
    }
    
    float slowscan(vec2 uv) {
        return sin(openfl_TextureSize.y * uv.y * 0.02 + iTime * 6.0);
    }
    
    vec2 colorShift(vec2 uv) {
        return vec2(
            uv.x,
            uv.y + sin(iTime)*0.02
        );
    }
    
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);
        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));
        vec2 u = smoothstep(0., 1., f);
        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;
    }
    
    vec2 crt(vec2 coord, float bend)
    {
        coord = (coord - 0.5) * 2.0;
        coord *= 0.5;	
        coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);
        coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);
        coord  = (coord / 1.0) + 0.5;
    
        return coord;
    }
    
    vec2 colorshift(vec2 uv, float amount, float rand) {
        
        return vec2(
            uv.x,
            uv.y + amount * rand // * sin(uv.y * iResolution.y * 0.12 + iTime)
        );
    }
    
    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0);
    	float amount = scan1 * scan2 * uv.x;
      uv = uv * 2.0 - 1.0;
      uv *= 0.9;
      uv = (uv + 1.0) * 0.5;
    	uv.x -= 0.02 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.2);

    	return uv;
         
    }
    
    float vignette(vec2 uv) {
        uv = (uv - 0.5) * 0.98;
        return clamp(pow(cos(uv.x * 3.1415), 1.2) * pow(cos(uv.y * 3.1415), 1.2) * 50.0, 0.0, 1.0);
    }
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        vec2 sd_uv = scandistort(uv);
        vec2 crt_uv = crt(sd_uv, 2.0);
        uv = crt_uv;
        vec4 video = getVideo(uv);
        float x =  0.;
        vec4 color;
        video.r = getVideo(vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
        video.g = getVideo(vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
        video.b = getVideo(vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
        video.r += 0.08*getVideo(0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
        video.g += 0.05*getVideo(0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
        video.b += 0.08*getVideo(0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;
        vec4 scanline_color = vec4(scanline(crt_uv));
        vec4 slowscan_color = vec4(slowscan(crt_uv));
        gl_FragColor = video;
          
    }