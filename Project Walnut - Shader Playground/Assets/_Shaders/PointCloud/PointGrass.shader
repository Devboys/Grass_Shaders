Shader "Custom/Grass/PointGrass"
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

            #pragma vertex vert
            //#pragma geometry geom
            #pragma fragment frag

            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct g2f 
            {
                float4 pos : SV_POSITION;
            };

            v2g vert(appdata_base v) 
            {
                v2g o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                return o;

            }
            
            [maxvertexcount(3)] //3 vert output cause we're extruding triangles.
            void geom(point v2g IN[1], inout TriangleStream<g2f> poiStream)
            {
                g2f OUT;

                //Top
                OUT.pos = UnityObjectToClipPos(IN[0].vertex.xyz);
                poiStream.Append(OUT);

                //BottomLeft
                float3 newPosBL = IN[0].vertex.xyz;
                newPosBL.x -= 1;
                newPosBL.y -= 1;

                OUT.pos = UnityObjectToClipPos(newPosBL);
                poiStream.Append(OUT);

                //BottomRight
                float3 newPosBR = IN[0].vertex.xyz;
                newPosBR.x += 1;
                newPosBR.y -= 1;

                OUT.pos = UnityObjectToClipPos(newPosBR);
                poiStream.Append(OUT);
            }

            half4 frag(g2f IN) : COLOR
            {
                return float4(1,1,1,1); //temporarily white.
            }

            ENDCG
        }
    }
}
