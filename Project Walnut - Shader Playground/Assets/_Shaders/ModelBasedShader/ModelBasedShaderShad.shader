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
            // Create variable names to read/write data in/out of unity/shader program
            #pragma vertex bob
            #pragma fragment cindy
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
                //float2 worldPos : TEXCOORD0;
            };
            
            struct vertexInput
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };
            
            
            vertexOutput bob(vertexInput vIn)
            {
                vertexOutput vOut;
                vOut.pos = UnityObjectToClipPos(vIn.pos);
                float4 normal4 = float4(vIn.normal, 0.0);    
                vOut.normal = normalize(mul(normal4, unity_WorldToObject).xyz); 
                // get vertex world position
                float4 worldPos = mul(unity_ObjectToWorld, vIn.pos);
                // normalize position based on world size
                float2 samplePos = worldPos.xz/_WorldSize.xz;
                // random - not working
             //missing random implementation               
                // scroll sample position based on time (and random "noise"- not yet)
                // Time (a float4) since level load (t/20, t, t*2, t*3)
                samplePos += _Time.x * _WindSpeed.xy;
                // get wind texture
                float windSample = tex2Dlod(_WindTex, float4(samplePos, 0,0)); 
                // test sample position           
                //vOut.worldPos = samplePos;
                // 0 animation below _HeightCutoff
                float heightFactor = vIn.pos.y > _HeightCutoff;
                // make animation stronger with height
                heightFactor = heightFactor * pow(vIn.pos.y, _HeightFactor);
                // apply wave animation
                vOut.pos.z += sin(_WaveSpeed*windSample)*_WaveAmp * heightFactor;
                vOut.pos.x += cos(_WaveSpeed*windSample)*_WaveAmp * heightFactor;
                // apply wave animation
                //vOut.pos.z += sin(_WaveSpeed*windSample)*_WaveAmp;
                //vOut.pos.x += cos(_WaveSpeed*windSample)*_WaveAmp;
                return vOut;
            }
            
            float4 cindy(vertexOutput fIn) : COLOR
            {
                /*  frac() takes the fractional component or the value of the
                    input after the decimal point which is between 0-1 and
                    loops it back round to 0 after it's passed 1
                */
                //return float4(frac(fIn.worldPos.y),0,0,1);
                
                // normalize light dir    
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);    
                // apply lighting    
                float ramp = clamp(dot(fIn.normal, lightDir), 0.001, 1.0);    
                float3 lighting = tex2D(_RampTex, float2(ramp, 0.5)).rgb;    
                float3 rgb = _LightColor0.rgb * lighting * _grassColor.rgb;    
                return float4(rgb, 1.0);
                
            }
            
            ENDCG
        }
    }
    FallBack "Diffuse"
}
