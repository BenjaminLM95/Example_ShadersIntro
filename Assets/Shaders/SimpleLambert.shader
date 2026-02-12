Shader "Custom/SimpleLambert_URP" // Single light (1 pass) 
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalRenderPipeline"
        }

        Pass
        {
            Tags { "LightMode"="UniversalForward" }

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex); // gets sampler settings from texture import 

            struct appData
            {
                float4 positionObjectSpace : POSITION;
                float3 normalObjectSpace : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 positionClipSpace : SV_POSITION;
                float3 normalWorldSpace : TEXCOORD0;
                float2 uv : TEXCOORD1;
              
            };

            v2f vert(appData input)
            {
                v2f output;

                output.positionClipSpace = TransformObjectToHClip(input.positionObjectSpace);
                output.normalWorldSpace = TransformObjectToWorldNormal(input.normalObjectSpace); // our light is in world space so we want our normal in world space as we will need to dot them 
                output.uv = input.uv;

                // tldr vert shader is only transforming vectors to the right space 
                // you may notice different method names compared to the unlit shaders because they used old approach from built-in render pipeline (we didn't need lighting)
                return output;
            }

            half4 frag(v2f input) : SV_Target
            {
                // normalize our normal vector. It is probably already normalized but no guarantee
                // some things could affect it such as scaling. 
                // PS: we need it normalized because normalized vectors give dot products between -1 and 1, which is sensical to work with.
                float3 normal = normalize(input.normalWorldSpace);

                // Light struct/ methods come from the Lighting.hlsl include above 
               
                Light mainLight = GetMainLight();
                float3 lightDir = normalize(mainLight.direction); // again we want two normalized vectors. This is the direction to the light
                // images.squarespace-cdn.com/content/v1/54851541e4b0fb60932ad015/1483897078629-QJOZ703T119UAEEEEOEU/image-asset.jpeg

                // take max of 0 and normal. Normal could be -1 but that means the light is coming from backside of face, which we want to be effectively the same as 0
                float normal_dot_light = max(0, dot(normal, lightDir)); // now we have a value 0 to 1 that represents how lined up the normal is with the direction to the light 
                // when the normal is 1 the light is shining directly at the normal 

                
            

                float4 tex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);


                float3 diffuse = tex.rgb * mainLight.color * normal_dot_light; // TODO: @me illustrate this on photoshop 

                return float4(diffuse, tex.a);
            }

            ENDHLSL

            // MINI CHALLENGES 
            
            // CHALLENGE I - BASIC TOON
            // Toon shading is pretty cool. How do you think it works? Can you figure out how to add toon banding? 
            // HINTS: 1) create a value for how many bands you have i.e     float bands = 4.0
            // HINTS: 2) maybe you can use the round or floor function? 
            // Super extra bonus: usually toon shading is not fully black even when no light hits the surface. How could you add a 'lift'? 

            // CHALLENGE II
            // Different Shadow Color 
            // Can you create a color that represents a shadow color, and then blend between the texture color and the shadow color? You may choose a dark red or dark blue color for a nice effect
            // HINTS: 1) can you lerp it? 

            // CHALLENGE III brainstorm together: How could we add rim lighting? Which vectors would we need 

        }
    }
}
