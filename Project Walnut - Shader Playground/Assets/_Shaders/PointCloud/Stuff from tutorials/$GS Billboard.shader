Shader "Custom/GS Billboard"
{
    Properties
    {
        _SpriteTex("Base (RGB)", 2D) = "white" {}
        _Size("Size", Range(0, 3)) = 0.5
    }

        SubShader
        {
            Pass
            {
                CGPROGRAM
                    #pragma target 5.0
                    #define UNITY_SHADER_NO_UPGRADE 1 //prevents mul from being replaced.
                    #pragma vertex VS_Main
                    #pragma fragment FS_Main
                    #pragma geometry GS_Main
                    #include "UnityCG.cginc" 

            // **************************************************************
            // Data structures												*
            // **************************************************************
            struct GS_INPUT
            {
                float4	pos		: POSITION;
                float3	normal	: NORMAL;
                float2  tex0	: TEXCOORD0;
            };

            struct FS_INPUT
            {
                float4	pos		: POSITION;
            };


            // **************************************************************
            // Vars															*
            // **************************************************************

            float _Size;
            float4x4 _VP;
            Texture2D _SpriteTex;
            SamplerState sampler_SpriteTex;

            // **************************************************************
            // Shader Programs												*
            // **************************************************************

            // Vertex Shader ------------------------------------------------
            GS_INPUT VS_Main(appdata_base v)
            {
                GS_INPUT output = (GS_INPUT)0;

                output.pos = mul(unity_ObjectToWorld, v.vertex);
                output.normal = v.normal;
                output.tex0 = float2(0, 0);

                return output;
            }



            // Geometry Shader -----------------------------------------------------
            [maxvertexcount(4)]
            void GS_Main(point GS_INPUT p[1], inout TriangleStream<FS_INPUT> triStream)
            {
                float3 up = float3(0, 1, 0);
                float3 look = _WorldSpaceCameraPos - p[0].pos;
                look.y = 0;
                look = normalize(look);
                float3 right = cross(up, look);

                float halfS = 0.5f * _Size;

                float4 v[4];
                v[0] = float4(p[0].pos + halfS * right - halfS * up, 1.0f);
                v[1] = float4(p[0].pos + halfS * right + halfS * up, 1.0f);
                v[2] = float4(p[0].pos - halfS * right - halfS * up, 1.0f);
                v[3] = float4(p[0].pos - halfS * right + halfS * up, 1.0f);

                float4x4 vp = mul(UNITY_MATRIX_MVP, unity_WorldToObject);
                FS_INPUT pIn;

                pIn.pos = mul(vp, v[0]);
                triStream.Append(pIn);

                pIn.pos = mul(vp, v[1]);
                triStream.Append(pIn);

                pIn.pos = mul(vp, v[2]);
                triStream.Append(pIn);

                pIn.pos = mul(vp, v[3]);
                triStream.Append(pIn);

            }



            // Fragment Shader -----------------------------------------------
            float4 FS_Main(FS_INPUT input) : COLOR
            {
                return float4(1.0, 1.0, 1.0, 1.0);
            }

        ENDCG
    }
        }
}
