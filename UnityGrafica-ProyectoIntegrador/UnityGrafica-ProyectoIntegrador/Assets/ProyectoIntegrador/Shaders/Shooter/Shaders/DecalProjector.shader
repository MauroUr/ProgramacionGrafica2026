// Shader para el componente Unity Projector: proyecta una marca de quemadura (decal)
// sobre cualquier superficie. Multiplica (oscurece) usando el alpha de la cookie.
Shader "Custom/DecalProjector"
{
	Properties
	{
		_ShadowTex ("Cookie (alpha = quemadura)", 2D) = "black" {}
		_Color ("Tinte quemadura", Color) = (0.05, 0.03, 0.02, 1)
	}
	Subshader
	{
		Tags { "Queue" = "Transparent" }
		Pass
		{
			ZWrite Off
			ColorMask RGB
			Blend DstColor Zero      // multiply -> oscurece la superficie
			Offset -1, -1

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4x4 unity_Projector;
			sampler2D _ShadowTex;
			fixed4 _Color;

			struct v2f
			{
				float4 uvShadow : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(vertex);
				o.uvShadow = mul(unity_Projector, vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// fuera del frustum del projector (detras) -> sin efecto (blanco = multiply neutro)
				if (i.uvShadow.w < 0) return fixed4(1,1,1,1);
				float2 uv = i.uvShadow.xy / i.uvShadow.w;
				if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1) return fixed4(1,1,1,1);
				fixed burn = tex2D(_ShadowTex, uv).a;
				// burn=0 -> blanco (sin cambio); burn=1 -> _Color (quemadura)
				return lerp(fixed4(1,1,1,1), _Color, burn);
			}
			ENDCG
		}
	}
}
