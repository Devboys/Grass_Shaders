Shader "Examples/GeometryExampleTwo"
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
            #pragma geometry geom
            #pragma fragment frag

            struct v2g
            {
                float4 pos : SV_POSITION;
                float3 norm : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct g2f
            {
                float4 pos: SV_POSITION;
                float4 col : ey;
            };

            v2g vert(appdata_full v)
            {
                float3 v0 = v.vertex.xyz;

                v2g OUT;
                OUT.pos = v.vertex;
                OUT.norm = v.normal;
                OUT.uv = v.texcoord;
                return OUT;
            }

            //declare the maximum vertex output of this geometry shader. This is for optimization.
            [maxvertexcount(6)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream, uint id : SV_PrimitiveID)
            {
                //read the three vertices of the input primitive
                float3 v0 = IN[0].pos.xyz;
                float3 v1 = IN[1].pos.xyz;
                float3 v2 = IN[2].pos.xyz;

                //calculate the normal vector of the primitive.
                float3 normal = normalize(cross(v1 - v0, v2 - v1));

                g2f OUT;

                //declare the color of the original primitives (white)
                OUT.col = 1;

                //pass all original primitives to the output.
                OUT.pos = UnityObjectToClipPos(v0);
                triStream.Append(OUT);
                OUT.pos = UnityObjectToClipPos(v1);
                triStream.Append(OUT);
                OUT.pos = UnityObjectToClipPos(v2);
                triStream.Append(OUT);
                
                //make sure the new primitives aren't considered extensions of the original primitives.
                triStream.RestartStrip();

                //transform only every other primitive.
                bool transformFactor = !(id & 1);

                //Create the new vertex positions by extending the position of every vertex in the original primitive along the normal vector by 0.1 units.
                v0 += normal * 0.1f * transformFactor;
                v1 += normal * 0.1f * transformFactor;
                v2 += normal * 0.1f * transformFactor;

                //declare the color of the new primitives (light grey).
                OUT.col = (1 - 0.3 * transformFactor);

                //use the output struct to append the new vertices to the geometry shader output, in clip space.
                OUT.pos = UnityObjectToClipPos(v0);
                triStream.Append(OUT);
                OUT.pos = UnityObjectToClipPos(v1);
                triStream.Append(OUT);
                OUT.pos = UnityObjectToClipPos(v2);
                triStream.Append(OUT);

            }

            half4 frag(g2f IN) : COLOR
            {
                return IN.col;
            }

            ENDCG
        }
    }
}
