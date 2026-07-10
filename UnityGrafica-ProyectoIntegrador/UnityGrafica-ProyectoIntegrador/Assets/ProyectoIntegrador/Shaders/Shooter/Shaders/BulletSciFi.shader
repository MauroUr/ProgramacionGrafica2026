Shader "Custom/BulletSciFi"
{
	Properties
	{
		_Color("Color", Color) = (0.35,0.9,1,1)
		_PlasmaTex("Plasma (grayscale tileable)", 2D) = "white" {}
		_Tiling("Tiling plasma", Float) = 2
		_Scroll("Scroll (xy)", Vector) = (0,-3,0,0)
		_FresnelPower("Fresnel Power", Range( 0.5 , 8)) = 2.5
		_FresnelBoost("Fresnel Boost", Range( 0 , 3)) = 0.8
		_PlasmaContrast("Plasma Contraste", Range( 1 , 6)) = 2.5
		_PlasmaBoost("Plasma Boost", Range( 0 , 6)) = 3
		_Core("Nucleo", Range( 0 , 3)) = 0.05
		_Intensity("Intensidad", Range( 0.2 , 20)) = 2
		_Opacity("Opacidad", Range( 0 , 1)) = 1
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		Blend SrcAlpha One
		ZWrite Off
		Cull Back

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			uniform sampler2D _PlasmaTex;
			uniform float4 _Color;
			uniform float _Tiling;
			uniform float4 _Scroll;
			uniform float _FresnelPower;
			uniform float _FresnelBoost;
			uniform float _PlasmaContrast;
			uniform float _PlasmaBoost;
			uniform float _Core;
			uniform float _Intensity;
			uniform float _Opacity;

			v2f vert ( appdata v )
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.uv;
				o.worldNormal = UnityObjectToWorldNormal( v.normal );
				float3 wp = mul( unity_ObjectToWorld, v.vertex ).xyz;
				o.viewDir = UnityWorldSpaceViewDir( wp );
				return o;
			}

			fixed4 frag ( v2f i ) : SV_Target
			{
				float3 n = normalize( i.worldNormal );
				float ndv = saturate( dot( n, normalize( i.viewDir ) ) );
				float fres = pow( 1.0 - ndv, _FresnelPower );

				float2 uv = i.uv * _Tiling + _Scroll.xy * _Time.y;
				float plasma = tex2D( _PlasmaTex, uv ).r;
				plasma = pow( saturate( plasma ), _PlasmaContrast );

				float energy = _Core + fres * _FresnelBoost + plasma * _PlasmaBoost;
				float3 col = _Color.rgb * energy * _Intensity;
				float a = saturate( ( _Core * 0.4 + fres * 0.5 + plasma * 1.2 ) * _Opacity );

				return fixed4( col, a );
			}
			ENDCG
		}
	}
	Fallback Off
}
