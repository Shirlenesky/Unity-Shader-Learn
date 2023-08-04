// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Distort shader
//by: puppet_master
//2017.4.24
Shader "Rin/Distort" 
{
	Properties
	{
		_DistortStrength("DistortStrength", Range(0,1)) = 0.2
		_DistortTimeFactor("DistortTimeFactor", Range(0,1)) = 1
		_NoiseTex("NoiseTexture", 2D) = "white" {}
	}
	SubShader
	{
		ZWrite Off
		Cull Off
		//GrabPass
		GrabPass
		{
			//�˴�����һ��ץ����ͼ�����ƣ�ץ������ͼ�Ϳ���ͨ��������ͼ����ȡ������ÿһ֡�����ж������ʹ���˸�shader��ֻ����һ������ץ������
			//����˴�Ϊ�գ���Ĭ��ץ����_GrabTexture�У����Ǿ�˵ÿ���������shader�Ķ������һ��ץ����
			"_GrabTempTex"
		}
 
		Pass
		{
			Tags
			{ 
				"RenderType" = "Transparent"
				"Queue" = "Transparent + 100"
			}
 
			CGPROGRAM
			sampler2D _GrabTempTex;
			float4 _GrabTempTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			float _DistortStrength;
			float _DistortTimeFactor;
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 grabPos : TEXCOORD1;
			};
 
			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.texcoord, _NoiseTex);
				return o;
			}
 
			fixed4 frag(v2f i) : SV_Target
			{
				//���Ȳ�������ͼ��������uvֵ����ʱ�������任�������һ������ͼ�е����ֵ������һ��Ť������ϵ��
				float4 offset = tex2D(_NoiseTex, i.uv - _Time.xy * _DistortTimeFactor);
				//�ò���������ͼ�����Ϊ�´β���Grabͼ��ƫ��ֵ���˴�����һ��Ť�����ȵ�ϵ��
				i.grabPos.xy -= offset.xy * _DistortStrength;
				//uvƫ�ƺ�ȥ������ͼ���ɵõ�Ť����Ч��
				fixed4 color = tex2Dproj(_GrabTempTex, i.grabPos);
				return color;
			}
 
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
}