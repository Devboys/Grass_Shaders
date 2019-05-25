Shader "Custom/ModelBasedShaderNoWind"
{
    Properties
    {
        _RampTex("Ramp", 2D) = "white" {}
        _grassColor("Grass Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _RampTex;
            float4 _grassColor;
            float4 _LightColor0; //unity delivers
            
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            struct vertexInput
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };
            
            
            vertexOutput vert(vertexInput vIn)
            {
                vertexOutput vOut;
                vOut.pos = UnityObjectToClipPos(vIn.pos);
                float4 normal4 = float4(vIn.normal, 0.0);    
                vOut.normal = normalize(mul(normal4, unity_WorldToObject).xyz); 

                return vOut;
            }
            
            float4 frag(vertexOutput fIn) : COLOR
            {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                // apply lighting    
                float ramp = clamp(dot(fIn.normal, lightDir), 0.001, 1.0);    
                float3 lighting = tex2D(_RampTex, float2(ramp, 0.5)).rgb;    
                float3 rgb = lighting * _grassColor.rgb;    
                return float4(rgb, 1.0);
            }
            
            ENDCG
        }
    }
    FallBack "Diffuse"
}
