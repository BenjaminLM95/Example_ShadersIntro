Shader "Unlit/UnlitTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
     

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100


        ZWrite Off // does the shader occlude other objects? 
        Blend SrcAlpha OneMinusSrcAlpha // how does the shader blend with the background?  Blend based on this object's alpha and 1 minus this object's alpha. 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

         

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
                o.uv = v.uv; // replace this line with the above line to enable tiling/offset. Try it out! 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               
                fixed4 col = tex2D(_MainTex, i.uv); // sample the texture. Looks at the texture at a normalized position (remember, uv's go from 0 to 1)
                //col.a = 0.2;
                //^ try uncommenting this line and see the transparency at work! 
                return col;
            }
            ENDCG
        }

        // MINI CHALLENGE: 
        // Create a masking shader. 
        // Imagine that you have some armor in your game and you want to be able to change the color of the trim
        // You plan on using a separate texture. You will use the alpha of that texture to know where to color the trim. 
        // Hints: You will need another tex2D, as well as a Color for the trim. 
            // You may also need to use lerp to figure out the final color! 
            // You  may need to sample the new texture to figure out its alpha! It can be stored in a fixed 
            // Dont forget to return the final color if you use a new variable. 
            
    }
}
