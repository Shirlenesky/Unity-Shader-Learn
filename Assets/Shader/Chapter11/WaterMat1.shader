// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 11/Water1"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Magnitude("Distortion Magnitude", Float) = 1
        _Frequency("Distortion Frequency", Float) = 1
        _InvWaveLenghth("Distortion Inverse Wave Length", Float) = 10
        _Speed("Speed", Float) = 0.5
    }
    SubShader
    {
        Tags 
        {
            "Queue" = "Transparent"
            "IgnoreProject" = "True"
            "RenderType"="Transparent" 
            "DisableBatching" = "True"
        }

        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            ZWrite off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            Float _Magnitude;
            Float _Frequency;
            Float _InvWaveLenghth;
            Float _Speed;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };
        
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                float4 offset;
                offset.yzw = float3(0.0, 0.0, 0.0);
                offset.x = sin(_Frequency * _Time.y + v.vertex.x * _InvWaveLenghth + v.vertex.y * _InvWaveLenghth + v.vertex.z * _InvWaveLenghth) *_Magnitude;

                o.pos = UnityObjectToClipPos(v.vertex + offset);

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv += float2(0.0, _Time.y * _Speed);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                c.rgb *= _Color.rgb;

                return c;
            }
            ENDCG
        }

    }
    FallBack "VertexLit"
}
