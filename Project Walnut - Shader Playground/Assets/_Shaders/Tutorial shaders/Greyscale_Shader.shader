Shader "Custom/GreyScale_Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Tint("Tint", Color) = (1,1,1,1)
	}
	SubShader
	{
        Tags
        {
            "Queue" = "Transparent"
        }

		Pass
		{
            Blend  SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
            float getLuminance(float4 p)
            {
                return (0.3 * p.r + 0.59 * p.g + 0.11 * p.b);
            }

			sampler2D _MainTex;
            float4 _Tint;

			float4 frag (v2f i) : SV_Target
			{
                float4 col = tex2D(_MainTex, i.uv);
                col.rgb = getLuminance(col); //no touching the alpha

                col *= _Tint;
				return col;
			}
			ENDCG
		}
	}
}
