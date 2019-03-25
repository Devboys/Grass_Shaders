Shader "Custom/Grass/PointGrassWind"
{
    Properties
    {
        _GHeight("Grass Height", range(0, 3)) = 0.5
        _GWidth("Grass Width", range(0, 3)) = 0.5

        _RotPoint("Rotation Point", Vector) = (0, 0, 0)
    }
        SubShader
    {
        Cull off //disable "view" culling, i.e. make triangles visible from backside too. Temp, very bad for performance, model both sides instead.

        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #include "Assets/_Shaders/ShaderUtils/ShaderUtilities.cginc"
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            float _GHeight;
            float _GWidth;
            float _RotAmount;
            float3 _RotPoint;

            struct v2g
            {
                float4 vertex : POSITION;
            };

            struct g2f 
            {
                float2 uv : UV;
                float4 vertex : POSITION;
            };

            v2g vert(appdata_base v) 
            {
                v2g o;
                o.vertex = mul(unity_ObjectToWorld, v.vertex);
                
                return o;
            }

            [maxvertexcount(3)] //3 vert output cause we're extruding triangles.
            void geom(point v2g IN[1], inout TriangleStream<g2f> triStream)
            {
                float3 center = IN[0].vertex.xyz;

                //define identity vectors to use in movement.
                float3 up = float3(0, 1, 0);
                float3 right = float3(1, 0, 0);
                float3 forward = float3(0, 0, 1);

                //side vertexes are offset half of _GWidth from center of grass.
                float halfWidth = (_GWidth) / 2;

                //grass height is randomized based on XZ world coordinates of grass.
                float heightCalculated = _GHeight * randomRange(center.xz, 0.5, 1);

                float4 pos[3];
                //WINDING ORDER CLOCKWISE, REMEMBER
                pos[0] = float4(center + up * heightCalculated, 1.0f);
                pos[1] = float4(center + right * halfWidth, 1.0f);
                pos[2] = float4(center - right * halfWidth, 1.0f);

                //get axis and angle of rotation to face point.
                float3 rotationVector = normalize(pos[0] - _RotPoint);
                float rotationAngle = acos(dot(up, rotationVector));
                float rotationAxis = normalize(cross(up, rotationVector));

                //rotate top vertex around rotationAxis by roationAngle
                pos[0] = float4(rotateAroundAxis(pos[0] - center, rotationAngle, rotationAxis) + center, 1);

                g2f OUT;
                //top
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[0]);
                OUT.uv = float2(0, 1);
                triStream.Append(OUT);

                //right
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[1]);
                OUT.uv = float2(0, 0);
                triStream.Append(OUT);

                //left
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[2]);
                OUT.uv = float2(1, 0);
                triStream.Append(OUT);
            }

            half4 frag(g2f IN) : COLOR
            {
                float4 col = float4(0.5, IN.uv.y, 0.5, 1);//temp, maybe do stuff with saturation.
                return col;
            }

            ENDCG
        }
    }
}
