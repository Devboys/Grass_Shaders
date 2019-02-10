Shader "Custom/Tween_Shader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
        _OtherTex("Other Texture", 2D) = "black"{}
        _Tween("Texture Tween", Range(0, 1)) = 1
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
			
			sampler2D _MainTex;
            sampler2D _OtherTex;
            float _Tween;

			fixed4 frag (v2f i) : SV_Target
			{
                fixed4 maincol = tex2D(_MainTex, i.uv);
                fixed4 otherCol = tex2D(_OtherTex, i.uv);
                fixed4 col = maincol * _Tween + otherCol * (1 - _Tween);
				return col;
			}
			ENDCG
		}
	}
}
