// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ColliderOriWater" {
    Properties{
        _MainTex("Base (RGB)", 2D) = "white" {}
        _CollisionPoint("Collision Point", float) = 0
        _CollisionForce("Collision Force", float) = 0
        _WaveMagnitude("Wave Magnitude", float) = 0.4
    }
        SubShader{
            Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha
            LOD 200
            Pass
            {
                CGPROGRAM
                #include "UnityCG.cginc"
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _MainTex;
                float _CollisionPoint;
                float _CollisionForce;
                float _WaveMagnitude;

                struct appdata {
                    half4 vertex : POSITION;
                    half4 uv : TEXCOORD0;
                };

                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                /**
                 * A convenient variation on Lerping that returns a value between start and end as the input value goes from min to max
                 *
                 * So if value <= min return start, if value >= max return end, otherwise return something lerpy in between
                 */
                half rangeLerp(half start, half end, half min, half max, half value)
                {
                    half lerpPercent = (value - min) / (max - min);
                    lerpPercent = clamp(lerpPercent, 0, 1);
                    return lerp(start, end, lerpPercent);
                }

                v2f vert(appdata i)
                {
                    v2f o;

                    half4 v = i.vertex;

                    //offset only the top-vertexes.
                    if (i.uv.y == 0)
                    {
                        half xDif = sqrt(pow((_CollisionPoint - v.x), 2));
                        half invXDif = rangeLerp(2, 0, 0, 5, xDif);
                        half offset =  _WaveMagnitude * (invXDif)* cos(xDif + _Time[3]) * _CollisionForce;
                        //half offset = _WaveMagnitude * xDif;

                        v.z += offset;
                    }
                    o.pos = UnityObjectToClipPos(v);

                    o.uv = i.uv;
                    return o;
                }

                half4 frag(v2f i) : COLOR
                {
                    half4 c = tex2D(_MainTex, i.uv);
                    c = half4(0.5, 0.5, 0.5, 1);


                    float vertCoord = (((_CollisionPoint + 5) / (5 + 5)) * (1 - 0) + 0);

                    //convert local-space to shader space. (local space is -5 to 5, frag space is 0 to 1)
                    float minMaxOffset = 0.005;

                    /*if (i.uv.r < vertCoord + minMaxOffset && i.uv.r > vertCoord - minMaxOffset && i.uv.g < 0.1) 
                    {
                        c = half4(1, 1, 1, 1);
                    }*/
                    return c;
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}
