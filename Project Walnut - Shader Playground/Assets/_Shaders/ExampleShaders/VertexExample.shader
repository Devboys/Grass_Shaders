Shader "Examples/VertexExample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", color) = (1, 1, 1, 1)
        _DispFactor("Displacement Factor", float) = 1
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            float _DispFactor;

            struct appdata {
                float4 vertex : POSITION;
                uint index : SV_VertexID;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                //declare output struct
                v2f o;

                //Get either 0 or 1 based on the index of the vertex being processed. The result is 0 if index is divible by 2, 1 otherwise.
                int transformFactor = !(v.index & 1);

                //use transformFactor to 'extend' the position of every other vertex, 0.1 units along its normal vector.
                float4 vertPos = v.vertex + (0.1 * transformFactor * v.normal);

                //convert the 'transformed' vertex position directly to clip space, using a built in function.
                vertPos = UnityObjectToClipPos(vertPos);

                //place the final vertex position into the output struct and return it.
                o.vertex = vertPos;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
