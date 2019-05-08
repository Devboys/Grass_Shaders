Shader "Examples/FragmentExample"
{
    Properties
    {
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
                //define two colors in RGBA
                fixed4 topColor = fixed4(1, 1, 1, 1);    //white
                fixed4 bottomColor = fixed4(1, 0, 0, 1); //red

                //linearly interpolate between the two colors, based on the fragment's position in respect to the mesh (uv position).
                fixed4 color = lerp(bottomColor, topColor, i.uv.y);

                //return the resulting color
                return color;
            }
            ENDCG
        }
    }
}
