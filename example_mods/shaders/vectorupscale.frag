/*Copyright 2020 Ethan Alexander Shulman
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    vec2 uv = fragCoord.xy / iResolution.xy;
	float sumOfDistance;
    float minDistance=500.;
    vec3 col1;
    vec3 col2;
    vec3 col3;
    vec3 clr;
  int MEDIAN_RADIUS=2;
    for(int row=-MEDIAN_RADIUS;row<=MEDIAN_RADIUS;row++)
    {
    for(int j=-MEDIAN_RADIUS;j<=MEDIAN_RADIUS;j++)
    {
        for(int i=-MEDIAN_RADIUS;i<=MEDIAN_RADIUS;i++)
            {
				sumOfDistance=0.;
                    for(int m=-MEDIAN_RADIUS;m<=MEDIAN_RADIUS;m++)
                        {
                            for(int n=-MEDIAN_RADIUS;n<=MEDIAN_RADIUS;n++)
                                {

                                            vec2 uv1=vec2((fragCoord.x+0.5+float(j+MEDIAN_RADIUS+i))/iResolution.x,(fragCoord.y+float(j+MEDIAN_RADIUS+i+row)+0.5)/iResolution.y);
                                            vec2 uv2=vec2((fragCoord.x+0.5+float(m+MEDIAN_RADIUS+n))/iResolution.x,(fragCoord.y+float(m+MEDIAN_RADIUS+n+row)+0.5)/iResolution.y);
                                            col1=texture(iChannel0,uv1).rgb;
                                            col2=texture(iChannel0,uv2).rgb;

                                            sumOfDistance+=distance(col1,col2);
                                    
                                    
                                }
                            
                           if (sumOfDistance<minDistance)
                            {
                                minDistance=sumOfDistance;
                                clr=col1;
                            }
                        }
                			
                
            }
        
        
    }
    
}
    

    fragColor = vec4(clr, flixel_texture2D(bitmap,uv).a);
}