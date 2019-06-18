Shader "Examples/UniformTessellation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Uniform("Uniform Tessellation", Range(1, 64)) = 1
        _TessMap("Tessellation Map", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex tes
            #pragma fragment frag
            #pragma hull hulls
            #pragma domain domains
            #pragma target 4.6
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct cp
            {
                float4 vertex : INTERNALTESSPOSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            struct tf
            {
                float edge[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
            };
            sampler2D _MainTex;
            sampler2D _TessMap;
            float4 _MainTex_ST;
            float _Uniform;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            cp tes (appdata v)
            {
                cp p;
                p.vertex = v.vertex;
                p.uv = v.uv;
                return p;
            }

            [UNITY_domain("tri")]
            [UNITY_outputcontrolpoints(3)]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_partitioning("integer")]
            [UNITY_patchconstantfunc("pcf")]
            cp hulls(InputPatch<cp, 3> patch, uint id : SV_OutputControlPointID)
            {
                return patch[id];
            }

            tf pcf(InputPatch<cp, 3> patch)
            {
                float p0factor = tex2Dlod(_TessMap, float4(patch[0].uv.x, patch[0].uv.y, 0, 0)).r;
                float p1factor = tex2Dlod(_TessMap, float4(patch[1].uv.x, patch[1].uv.y, 0, 0)).r;
                float p2factor = tex2Dlod(_TessMap, float4(patch[2].uv.x, patch[2].uv.y, 0, 0)).r;
                float factor = (p0factor + p1factor + p2factor);
                tf f;
                f.edge[0] = factor > 0.0 ? _Uniform : 1.0;
                f.edge[1] = factor > 0.0 ? _Uniform : 1.0;
                f.edge[2] = factor > 0.0 ? _Uniform : 1.0;
                f.inside = factor > 0.0 ? _Uniform : 1.0;
                return f;
            }

            [UNITY_domain("tri")]
            v2f domains(tf factors,
                OutputPatch<cp, 3> patch,
                float3 barycentricCoordinates : SV_DomainLocation)
            {
                appdata data;
                data.vertex = 
                    patch[0].vertex * barycentricCoordinates.x +
                    patch[1].vertex * barycentricCoordinates.y +
                    patch[2].vertex * barycentricCoordinates.z;
                data.uv = 
                    patch[0].uv * barycentricCoordinates.x +
                    patch[1].uv * barycentricCoordinates.y +
                    patch[2].uv * barycentricCoordinates.z;
                return vert(data);
            }
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}