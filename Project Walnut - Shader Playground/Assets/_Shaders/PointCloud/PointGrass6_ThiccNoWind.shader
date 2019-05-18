Shader "Grass/PointGrass/PointGrassThiccNoWind"
{
    Properties
    {
        _GHeight("Grass Height", range(0, 3)) = 0.5
        _GWidth("Grass Width", range(0, 0.5)) = 0.2

        _GColBot("Bottom Color", Color) = (0,0,0,0)
        _GColTop("Top Color", Color) = (1,1,1,1)

        _WindVec("Wind Direction", Vector) = (1, 1, 1)
        _RotAngle("Rotation Angle", range(-90, 90)) = 0
    }
    SubShader
    {
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
            float4 _GColBot;
            float4 _GColTop;
            float _RotAngle;
            float3 _WindVec;

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

            [maxvertexcount(8)]
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

                float4 pos[4];
                //WINDING ORDER CLOCKWISE, REMEMBER
                pos[0] = float4(center + up * heightCalculated, 1.0f);
                pos[1] = float4(center + right * halfWidth, 1.0f);
                pos[2] = float4(center - right * halfWidth, 1.0f);
                pos[3] = float4(center + forward * halfWidth, 1.0f);

                /* this looks wierd, and grainy
                pos[1].z += randomRange(pos[1].xz, 0, 0.04);
                pos[2].z += randomRange(pos[2].xz, 0, 0.04);
                */


                //Define rotation vector and angle based on given wind-direction
                /*float3 directionVector = normalize(_WindVec);
                float rotationAngle = angleToRad(_RotAngle) * sin(_Time[3]);
                float3 rotationAxis = normalize(cross(up, directionVector));*/

                //rotate top vertex around rotationAxis by roationAngle
                //pos[0] = float4(rotateAroundAxis(pos[0].xyz - center, rotationAngle, rotationAxis) + center, 1);

                g2f OUT;

                //front tri
                //top
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[0]);
                OUT.uv = float2(0, 1);
                triStream.Append(OUT);
                //right
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[1]);
                OUT.uv = float2(1, 0);
                triStream.Append(OUT);
                //left
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[2]);
                OUT.uv = float2(0, 0);
                triStream.Append(OUT);

                //back tri 1
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[3]);
                OUT.uv = float2(0, 0);
                triStream.Append(OUT);

                OUT.vertex = mul(UNITY_MATRIX_VP, pos[0]);
                OUT.uv = float2(0, 1);
                triStream.Append(OUT);

                //back tri 2
                OUT.vertex = mul(UNITY_MATRIX_VP, pos[3]);
                OUT.uv = float2(0, 0);
                triStream.Append(OUT);

                OUT.vertex = mul(UNITY_MATRIX_VP, pos[1]);
                OUT.uv = float2(0, 0);
                triStream.Append(OUT);
            }

            half4 frag(g2f IN) : COLOR
            {
                float4 col = lerp(_GColBot, _GColTop, IN.uv.y); //float4(czm_saturation(float3(0,1,0), sat), 1);
                return col;
            }

            ENDCG
        }
    }
}
