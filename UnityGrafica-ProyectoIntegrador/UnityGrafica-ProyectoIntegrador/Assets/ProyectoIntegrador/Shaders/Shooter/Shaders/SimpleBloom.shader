// Bloom simple para Built-in RP (PI_02 - Big Gun). Satura la luz de la emision (disparos/armas).
Shader "Custom/SimpleBloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BloomTex ("Bloom", 2D) = "black" {}
		_Threshold ("Threshold", Float) = 0.7
		_Intensity ("Intensity", Float) = 1.2
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		// Pass 0 - Bright pass (extrae zonas brillantes)
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex; float _Threshold;
			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);
				float b = max(max(c.r, c.g), c.b);
				float k = saturate(b - _Threshold) / max(b, 0.0001);
				return c * k;
			}
			ENDCG
		}

		// Pass 1 - Blur separable (direccion en _Dir)
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex; float4 _Dir;
			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 d = _Dir.xy;
				fixed4 col = tex2D(_MainTex, i.uv) * 0.227027;
				col += tex2D(_MainTex, i.uv + d * 1.3846) * 0.316216;
				col += tex2D(_MainTex, i.uv - d * 1.3846) * 0.316216;
				col += tex2D(_MainTex, i.uv + d * 3.2308) * 0.070270;
				col += tex2D(_MainTex, i.uv - d * 3.2308) * 0.070270;
				return col;
			}
			ENDCG
		}

		// Pass 2 - Composite (original + bloom)
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex; sampler2D _BloomTex; float _Intensity;
			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);
				fixed4 bloom = tex2D(_BloomTex, i.uv);
				return c + bloom * _Intensity;
			}
			ENDCG
		}
	}
}
