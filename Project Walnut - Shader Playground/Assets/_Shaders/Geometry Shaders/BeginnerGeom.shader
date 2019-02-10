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
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            
            struct v2g
            {
                float4 objPos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;

            };

            struct g2f
            {
                float4 worldPos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 col : COLOR;
            };

            v2g vert(appdata v)
            {

            }

            [maxvertexcount(12)]
            g2f geom(v2g p) 
            {

            }

            float4 frag(g2f i)
            {

            }
			ENDCG
		}
	}
}
