Shader "Custom/Grass/PointGrass_Base"
{
    Properties
    {

        _Size("Size", Range(0, 3)) = 0.5
    }
        SubShader
    {
        Cull off //disable "view" culling, i.e. make triangles visible from backside too.

        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #define UNITY_SHADER_NO_UPGRADE 1 //prevents mul from being replaced.
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            float _Size;

            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct g2f 
            {
                float4 vertex : POSITION;
            };

            v2g vert(appdata_base v) 
            {
                v2g o;
                o.vertex = mul(unity_ObjectToWorld, v.vertex);
                o.normal = v.normal;
                return o;

            }
            
            [maxvertexcount(3)] //3 vert output cause we're extruding triangles.
            void geom(point v2g IN[1], inout TriangleStream<g2f> triStream)
            {

                float3 top = IN[0].vertex.xyz;
                float4x4 vp = mul(UNITY_MATRIX_MVP, unity_WorldToObject);
                float halfSize = _Size * 0.5f;

                float3 up = float3(0, 1, 0);
                float3 left = float3(-1, 0, 0);
                float3 right = float3(1, 0, 0);

                float4 pos[3];
                //WINDING ORDER CLOCKWISE, REMEMBER
                pos[0] = float4(top, 1.0f);
                pos[1] = float4(top + right * halfSize - up * halfSize, 1.0f);
                pos[2] = float4(top + left * halfSize - up * halfSize, 1.0f);

                g2f OUT;

                OUT.vertex = mul(vp, pos[0]);
                triStream.Append(OUT);

                OUT.vertex = mul(vp, pos[1]);
                triStream.Append(OUT);

                OUT.vertex = mul(vp, pos[2]);
                triStream.Append(OUT);

                OUT.vertex = mul(vp, pos[0]);
                triStream.Append(OUT);

                triStream.RestartStrip();


            }

            half4 frag(g2f IN) : COLOR
            {
                return float4(0,1,0,1); //temporarily white.
            }

            ENDCG
        }
    }
}
