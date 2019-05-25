Shader "Custom/ModelBasedShaderShad"
{
    Properties
    {
        //  Parameters/variables that can be adjusted in unity
        _WorldSize("World Size", vector) = (1, 1, 1, 1)
        _WindSpeed("Wind Speed", vector) = (1, 1, 1, 1)
        _WaveSpeed("Wave Speed", float) = 1.0
        _WaveAmp("Wave Amp", float) = 1.0
        _WindTex("Wind Texture", 2D) = "white" {}
        _HeightCutoff("Height Cutoff", float) = 1.0
        _HeightFactor("Height Factor", float) = 1.0
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

            float4 _WorldSize;
            float4 _WindSpeed;
            sampler2D _WindTex;
            float4 _WindTex_ST;
            float _WaveSpeed;
            float _WaveAmp;
            float _HeightCutoff;
            float _HeightFactor;
            sampler2D _RampTex;
            float4 _grassColor;
            float4 _LightColor0; //unity delivers
            
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            float randomRange(float2 st, float min, float max) 
            {
                float num = frac(sin(dot(st.xy,
                float2(12.9898, 78.233)))* 43758.5453123);
                return (num + min) * (max-min);
            }
            
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

                // get vertex world position
                float4 worldPos = mul(unity_ObjectToWorld, vIn.pos);

                // normalize position based on world size
                float2 samplePos = worldPos.xz/_WorldSize.xz;

                // get random
                float rand = randomRange(samplePos, 1.1, 1.5);
                float randOne = randomRange(samplePos, 1.1, 1.5);
                float randTwo = randomRange(samplePos, 1.1, 1.5);    

                // scroll sample position based on time (and random "noise"- not yet)
                samplePos += _Time.x * _WindSpeed.xy * rand;

                // get wind texture
                float windSample = tex2Dlod(_WindTex, float4(samplePos, 0,0)); 

                // 0 animation below _HeightCutoff
                float heightFactor = vIn.pos.y > _HeightCutoff;

                // make animation stronger with height
                heightFactor = heightFactor * pow(vIn.pos.y, _HeightFactor);

                // apply wave animation
                vOut.pos.z += sin(_WaveSpeed*windSample)*_WaveAmp * heightFactor * randOne;
                vOut.pos.x += cos(_WaveSpeed*windSample)*_WaveAmp * heightFactor * randTwo;

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
