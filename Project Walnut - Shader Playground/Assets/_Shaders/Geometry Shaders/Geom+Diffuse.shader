// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GeomDiffuse"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
        //_WaterTex("Water Texture", 2D)  = "white" {}
	}
	SubShader
	{
		

		Pass
		{
            
            //_WorldSpaceLightPos0

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
                float3 color : TEXCOORD1;
            };

            struct g2f
            {
                float4 pos: SV_POSITION;
                float3 norm : NORMAL;
                //float2 uv: TEXCOORD0;
                float3 diffuseColor: TEXCOORD1;
                //float3 specularColor : TEXCOORD2;
            };

            sampler2D _MainTex;

            v2g vert(appdata_full v)
            {
                float3 v0 = v.vertex.xyz;

                v2g OUT;
                OUT.pos = v.vertex;
                OUT.norm = v.normal;
                OUT.uv = v.texcoord;

                OUT.color = tex2Dlod(_MainTex, v.texcoord).rgb;
                return OUT;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream) 
            {

                float3 lightPosition = _WorldSpaceLightPos0;

                float3 v0 = IN[0].pos.xyz;
                float3 v1 = IN[1].pos.xyz;
                float3 v2 = IN[2].pos.xyz;

                float3 normal = normalize(cross(v1 - v0, v2 - v1));
                float3 worldNormal = UnityObjectToClipPos(normal);

                float3 color = (IN[0].color + IN[1].color + IN[2].color) / 3;

                float lightStrength = max(dot(normalize(lightPosition), normal), 0);
                /*lightStrength = 1;*/

                g2f OUT;

                OUT.pos = UnityObjectToClipPos(v0);
                OUT.norm = normal;
                OUT.diffuseColor = color * lightStrength;
                triStream.Append(OUT);

                OUT.pos = UnityObjectToClipPos(v1);
                OUT.norm = normal;
                OUT.diffuseColor = color * lightStrength;
                triStream.Append(OUT);

                OUT.pos = UnityObjectToClipPos(v2);
                OUT.norm = normal;
                OUT.diffuseColor = color * lightStrength;
                triStream.Append(OUT);
            }

            half4 frag(g2f IN) : COLOR 
            {
                return float4(IN.diffuseColor.rgb, 1.0);
            }

			ENDCG
		}
	}
}
