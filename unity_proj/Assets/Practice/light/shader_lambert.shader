Shader "Practice/light/shader_lambert"
{
    Properties
    {
        _Intensity("Intensity",float) = 1
    }
    SubShader
    {

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 world_normal : TEXCOORD0;
                

            };
            half _Intensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.world_normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Diffuse = Ambient + Kd * LightColor * max(0,dot(N,L))
                fixed4 ambient = unity_AmbientSky;
                half kd = _Intensity;
                fixed4 light_color = _LightColor0;
                fixed3 N = normalize(i.world_normal);
                half N_dot_L = max(0,dot(N,_WorldSpaceLightPos0));
                fixed4 Diffuse = ambient + kd * light_color * N_dot_L;
                return Diffuse;
            }
            ENDCG
        }

        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend one one
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            #pragma skip_variants DIRECTIONAL
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                fixed4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 uv : TEXCOORD0;
                float3 world_normal : TEXCOORD1;
                float3 world_pos :TEXCOORD2;
            };
            half _Intensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.world_pos = mul(unity_ObjectToWorld,v.vertex);
                o.world_normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Diffuse = Ambient + Kd * LightColor * max(0,dot(N,L))
                //灯光空间坐标
                float3 vert_light_coord = mul(unity_WorldToLight,float4(i.world_pos,1)).xyz;
                
                fixed4 atten = tex2D(_LightTexture0,dot(vert_light_coord,vert_light_coord));
                fixed4 ambient = unity_AmbientSky;
                half kd = _Intensity;
                fixed4 light_color = _LightColor0 * atten;
                fixed3 N = normalize(i.world_normal);
                half N_dot_L = max(0,dot(N,_WorldSpaceLightPos0));
                fixed4 Diffuse = ambient + kd * light_color * N_dot_L ;
                return Diffuse;
            }
            ENDCG
        }
    }
}
