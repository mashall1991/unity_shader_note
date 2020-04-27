Shader "taecg/URP/SimplestUnlit"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("MainTex",2D) = "white"{}
    }

    SubShader
    {
        Tags
        {
            //告诉引擎此SubShader是用于URP渲染管线下的
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "Queue"="Geometry+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
            
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
            half4 _Color;
            CBUFFER_END

            // sampler2D _MainTex;
            TEXTURE2D(_MainTex);    //纹理的定义，如果是编绎到GLES2.0平台，则相当于sampler2D _MainTex;否则就相当于Texture2D _MainTex;
            float4 _MainTex_ST;
            // SAMPLER(sampler_MainTex);   //采样器的定义，如果是编绎到GLES2.0平台，就相当于空，否则就相当于SamplerState sampler_MainTex;
            #define smp _linear_clampU_mirrorV
            SAMPLER(smp);

            //顶点着色器的输入(模型的数据信息)
            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 uv:TEXCOORD;
            };
            
            //顶点着色器的输出
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float2 uv:TEXCOORD;
            };

            // v2f vert(appdata v)
            // 顶点着色器
            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;
                float3 positionWS = TransformObjectToWorld(v.positionOS);
                o.positionCS = TransformWorldToHClip(positionWS);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                return o;
            }

            //fixed4 frag(v2f i):SV_TARGET
            //片断着色器
            half4 frag(Varyings i) : SV_TARGET 
            {    
                half4 c;

                // half4 mainTex = tex2D(_MainTex,i.uv); 默认管线的纹理采样操作
                half4 mainTex = SAMPLE_TEXTURE2D(_MainTex,smp,i.uv);
                c = mainTex * _Color;

                return c;
            }

            ENDHLSL
        }   
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
