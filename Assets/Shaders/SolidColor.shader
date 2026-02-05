Shader "Unlit/CustomSolidColor" // <----- String determines the asset creation menu location 
{
    // ShaderLab properties. These will be visible on the material. 
    
    Properties
    {
        _Color ("Color", Color) = (0,0,0,0)
        //^name  ^inspector ^type   ^ default value
        //        text 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" } // tags are Unity magic. We could 
        LOD 100

        Pass
        {
            CGPROGRAM
           
            #pragma vertex vert // tells compiler to use 'vert' method for vertex shader
            #pragma fragment frag // and 'frag' method for fragment shader 
         

            #include "UnityCG.cginc" // this include has a bunch of stuff like _Time, 

            // struct that gets data from buffers such as UV1/2/3, position, normal, color (vertex colors) 
            // unity's renderer handles this 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                //float3 normal : NORMAL; <- we can add things to this struct if we will need them 
            };

            struct v2f // "vert to frag" 
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

          
            float4 _Color;

            v2f vert (appdata v) // <-- note that this method takes in appdata struct (v for vert) 
            {
                v2f o; // o for 'output' -- SHADER VARIABLE NAMES TEND TO SUCK
                // short names used because math formulas long && because of culture 
               
                o.vertex = UnityObjectToClipPos(v.vertex); // get the vert from object space (local to mesh) to clip space 
                
                // in clip space things are not pixels yet, but this is where 'clipping' happens. Part of a model can be out of camera frustum! 
                o.uv = v.uv;
                return o;
            }

            // this is our fragment Shader
            // the input to the frag shader is the output from the vert shader 
            fixed4 frag (v2f i) : SV_Target // <-- runs for very frag. A fragment is not quite synonymous with a pixel. But for now you can think this way. 
            {
                //                    ^ render target 
                fixed4 col = _Color;
                
                // RGBA color. 
                // can use .r .g .b .a or .x .y .z .w 

                return col;
            }
            ENDCG

            // MINI CHALLENGES 

            // 1) Make the shader red by selecting the color in a material. 
            
            // 2) Set it back to white. Now make the shader red by changing the line "fixed4 col = _Color"! 
                // hint: unlike c# you dont need to write the 'new' keyword to create a struct. 
            
                // 3) Lets use _Time!
            // We will still ignore _Color for this one. 
            // Make the shader oscillate between black and white by using _Time and sin() 
            // Hint: Sin is -1 to 1 but you want rgba of 0 to 1. How can you make that work? 
            // Hint: _Time has xyzw components: x = t/20, y = t, z = t*2, w = t*3    (meaning you may want to just use _Time.y) 
            // Extra: now try using the entire _Time.xyzw and see what happens! 
            
            
            // 4) can you use the uv's in the rgba values to create a gradient? (remember that our v2f struct called i has a float2 called uv (access them using uv.x and uv.y)

            // 5) so far we only touched the frag shader.  
            // Can you do the following in the vert shader? 
                // A) Make the entire object move up and down using sin() and _Time? 
                // B) Make the object scale up and down with sin() and _Time? 
        }
    }
}
