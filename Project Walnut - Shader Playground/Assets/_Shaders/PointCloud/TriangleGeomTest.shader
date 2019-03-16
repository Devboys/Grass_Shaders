Shader "Custom/Grass/TriangleGeomTest"
{
    Properties
    {
    }
    SubShader
    {
        Pass 
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #define UNITY_SHADER_NO_UPGRADE 1 //prevents mul from being replaced.
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct g2f 
            {
                float4 vertex : SV_POSITION;
            };

            v2g vert(appdata_base v) 
            {
                v2g o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                return o;

            }
            
            [maxvertexcount(4)] //3 vert output cause we're extruding triangles.
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f OUT;

                float4 top = IN[0].vertex;

                float4x4 vp = mul(UNITY_MATRIX_MVP, unity_WorldToObject);

                //Top
                OUT.vertex = mul(vp, top);
                triStream.Append(OUT);

                //top.x -= 0.1;

                float4 right = top;
                right.x -= 0.5;

                OUT.vertex = mul(vp, right);
                triStream.Append(OUT);

                float4 left = top;
                left.x += 0.5;
                //top.x += 0.2;

                OUT.vertex = mul(vp, left);
                triStream.Append(OUT);

            }

            half4 frag(g2f IN) : COLOR
            {
                return float4(1,1,1,1); //temporarily white.
            }

            ENDCG
        }
    }
}
