// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BeginnerGeom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
                //float3 norm : NORMAL;
                //float2 uv: TEXCOORD0;
                //float3 diffuseColor: TEXCOORD1;
                //float3 specularColor : TEXCOORD2;
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

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream) 
            {
                float3 v0 = IN[0].pos.xyz;
                float3 v1 = IN[1].pos.xyz;
                float3 v2 = IN[2].pos.xyz;

                float3 normal = normalize(cross(v1 - v0, v2 - v1));
                float3 worldNormal = UnityObjectToClipPos(normal);

                v0 += normal * 0.1f;
                v1 += normal * 0.1f;
                v2 += normal * 0.1f;


                g2f OUT;
                

                OUT.pos = UnityObjectToClipPos(v0);
                //OUT.norm = normal;
                triStream.Append(OUT);

                OUT.pos = UnityObjectToClipPos(v1);
                //OUT.norm = normal;
                triStream.Append(OUT);

                OUT.pos = UnityObjectToClipPos(v2);
                //OUT.norm = normal;
                triStream.Append(OUT);
            }

            half4 frag(g2f IN) : COLOR 
            {
                return float4(1, 1, 1, 1);
            }

			ENDCG
		}
	}
}
