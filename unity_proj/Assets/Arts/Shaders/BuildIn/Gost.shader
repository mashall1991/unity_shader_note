Shader "taecg/Gost"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" }
        Blend One One

        // Stencil
        // {
            //     Ref 1
            //     Comp NotEqual
            //     Pass Replace
        // }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                half3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
                half3 normalWS:NORMAL;
                float3 positionWS:TEXCOORD1;
                float3 positionOS:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.x += sin(v.vertex.y * 3 + _Time.y) * 0.1;
                v.vertex.z += sin(v.vertex.x * 5 + _Time.y + 0.5) * 0.03;
                o.positionCS = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normalWS = UnityObjectToWorldNormal(v.normal);
                o.positionWS = mul(unity_ObjectToWorld,v.vertex);
                o.positionOS = v.vertex;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c;

                half3 L = _WorldSpaceLightPos0;
                half3 N = normalize(i.normalWS);
                half3 V = normalize(UnityWorldSpaceViewDir(i.positionWS));
                half3 H = normalize(L+V);
                half dotNH = max(0,dot(N,H));
                half dotNL = max(0,dot(N,L));
                // return dotNL;

                half fresnel = 2*pow(1-max(0,dot(N,V)),3);

                // fixed mask= smoothstep(0.15,0.3,(i.positionOS.y-0.5));
                fixed mask= saturate(i.positionOS.y*1.5+i.positionOS.x*0.5);
                // return (fresnel + mask * 0.8 )* _Color;
                // mask =  mask * dotNL;
                // c = mask;
                c = fresnel * mask + mask * _Color * 1.2;

                return c;

            }
            ENDCG
        }
    }
}
