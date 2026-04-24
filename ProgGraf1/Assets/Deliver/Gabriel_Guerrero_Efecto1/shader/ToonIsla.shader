// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ToonIsla"
{
	Properties
	{
		_HeightMap("Height Map", 2D) = "black" {}
		_NubeEscala("Nube Escala", Float) = 50
		_NubeVelocidad("Nube Velocidad", Float) = 0.05
		_TextureSample0("Texture Sample 0", 2D) = "black" {}
		_NubeUmbral("Nube Umbral", Range( 0 , 1)) = 0.5
		_AlturaMinima("Altura Minima", Float) = 0
		_NubeSuavidad("Nube Suavidad", Range( 0 , 0.5)) = 0.15
		_AlturaMaxima("Altura Maxima", Float) = 5
		_TexturaArena("Textura Arena", 2D) = "white" {}
		_NubeIntensidad("Nube Intensidad", Range( 0 , 1)) = 0.5
		_TexturaHierba("Textura Hierba", 2D) = "white" {}
		_TexturaRocaCima("Textura Roca / Cima", 2D) = "white" {}
		_TexturaTiling("Textura Tiling", Float) = 4
		_UmbralHierba("Umbral Hierba", Range( 0 , 1)) = 0.3
		_UmbralRoca("Umbral Roca", Range( 0 , 1)) = 0.65
		_ZoneBlendWidth("Zone Blend Width", Range( 0 , 0.2)) = 0.05
		_ShadowThreshold("Shadow Threshold", Range( 0 , 1)) = 0.5
		_NivelDelAgua("Nivel Del Agua", Float) = 0
		_Tesselletion("Tesselletion", Float) = 0
		_AnchoBandaMojada("Ancho Banda Mojada", Range( 0 , 2)) = 0.3
		_TinteMojado("Tinte Mojado", Color) = (0.45,0.38,0.25,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _AlturaMinima;
		uniform float _AlturaMaxima;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _NubeUmbral;
		uniform float _NubeSuavidad;
		uniform float _NubeEscala;
		uniform float _NubeVelocidad;
		uniform float _NubeIntensidad;
		uniform sampler2D _TexturaArena;
		uniform float _TexturaTiling;
		uniform sampler2D _TexturaHierba;
		uniform sampler2D _TexturaRocaCima;
		uniform float _UmbralRoca;
		uniform float _ZoneBlendWidth;
		uniform sampler2D _HeightMap;
		uniform float4 _HeightMap_ST;
		uniform float _UmbralHierba;
		uniform float _ShadowThreshold;
		uniform float4 _TinteMojado;
		uniform float _NivelDelAgua;
		uniform float _AnchoBandaMojada;
		uniform float _Tesselletion;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _Tesselletion);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float lerpResult50 = lerp( _AlturaMinima , _AlturaMaxima , tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) ).r);
			v.vertex.xyz += ( float3(0,1,0) * lerpResult50 );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float temp_output_82_0 = ( _Time.y * _NubeVelocidad );
			float2 appendResult72 = (float2(( ( ase_worldPos.x / _NubeEscala ) + temp_output_82_0 ) , ( ( ase_worldPos.z / _NubeEscala ) + ( temp_output_82_0 * 0.5 ) )));
			float simplePerlin2D89 = snoise( appendResult72 );
			simplePerlin2D89 = simplePerlin2D89*0.5 + 0.5;
			float smoothstepResult69 = smoothstep( ( _NubeUmbral - _NubeSuavidad ) , ( _NubeUmbral + _NubeSuavidad ) , simplePerlin2D89);
			float2 temp_output_8_0 = ( i.uv_texcoord * _TexturaTiling );
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			float4 tex2DNode1 = tex2D( _HeightMap, uv_HeightMap );
			float smoothstepResult5 = smoothstep( ( _UmbralRoca - _ZoneBlendWidth ) , ( _UmbralRoca + _ZoneBlendWidth ) , tex2DNode1.r);
			float4 lerpResult12 = lerp( tex2D( _TexturaHierba, temp_output_8_0 ) , tex2D( _TexturaRocaCima, temp_output_8_0 ) , smoothstepResult5);
			float smoothstepResult4 = smoothstep( ( _UmbralHierba - _ZoneBlendWidth ) , ( _UmbralHierba + _ZoneBlendWidth ) , tex2DNode1.r);
			float4 lerpResult13 = lerp( tex2D( _TexturaArena, temp_output_8_0 ) , lerpResult12 , smoothstepResult4);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult16 = dot( ase_worldlightDir , ase_worldNormal );
			float4 lerpResult22 = lerp( ( lerpResult13 * 0.4 ) , lerpResult13 , step( (0.0 + (_ShadowThreshold - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , dotResult16 ));
			float smoothstepResult64 = smoothstep( _NivelDelAgua , ( _NivelDelAgua + _AnchoBandaMojada ) , ase_worldPos.y);
			float4 lerpResult29 = lerp( lerpResult22 , ( lerpResult22 * _TinteMojado ) , ( 1.0 - smoothstepResult64 ));
			c.rgb = ( ( 1.0 - ( ( 1.0 - smoothstepResult69 ) * _NubeIntensidad ) ) * lerpResult29 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
390;73;1163;719;457.5518;543.4313;2.587376;True;False
Node;AmplifyShaderEditor.CommentaryNode;90;-1200.102,1139.034;Inherit;False;2265.376;1007.282;Nubes;14;86;72;73;74;71;70;89;69;67;68;75;76;91;92;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;92;-1195.678,1642.012;Inherit;False;570.5353;338.652;Panner Control velocidad y direccion;6;66;84;82;83;78;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-975.8689,1726.957;Inherit;False;Property;_NubeVelocidad;Nube Velocidad;2;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1334.058,231.1207;Inherit;False;571.7289;454.7308;transición suave;7;3;33;2;38;37;39;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;95;-1201.468,666.7186;Inherit;False;447.9999;268.9994;Scale Control;3;7;8;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;83;-1127.678,1842.589;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;91;-1194.56,1281.153;Inherit;False;417.6996;349.8846; tamaño de las nubes ;4;79;80;85;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;85;-1178.56,1330.153;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-1284.058,381.3865;Inherit;False;Property;_UmbralRoca;Umbral Roca;14;0;Create;True;0;0;0;False;0;False;0.65;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-778.0781,1893.69;Inherit;False;Constant;_WindZ;WindZ;-1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1284.058,481.3866;Inherit;False;Property;_ZoneBlendWidth;Zone Blend Width;15;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1151.468,776.718;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-1073.303,1528.038;Inherit;False;Property;_NubeEscala;Nube Escala;1;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-914.676,1823.664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1086.468,716.7186;Inherit;False;Property;_TexturaTiling;Textura Tiling;12;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1284.058,281.3865;Inherit;False;Property;_UmbralHierba;Umbral Hierba;13;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;79;-881.8608,1450.094;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-741.6747,1807.119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;77;-882.0586,1356.269;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-934.7297,459.9196;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-933.6628,550.8516;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-915.4676,778.7181;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-999.2012,40.65396;Inherit;True;Property;_HeightMap;Height Map;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-560.5555,1572.886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-928.3287,281.1207;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-502.4681,886.718;Inherit;True;Property;_TexturaRocaCima;Textura Roca / Cima;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-502.4681,686.7181;Inherit;True;Property;_TexturaHierba;Textura Hierba;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;5;-640.8663,415.3872;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-922.9968,374.1861;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;-950,-500;Inherit;False;952;433;Toon;6;14;15;16;18;19;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-770.1432,1685.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-387.7188,1678.816;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-203.8403,1806.916;Inherit;False;Property;_NubeUmbral;Nube Umbral;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;4;-667.532,221.6556;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;14;-900,-400;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;73;-209.7546,1883.71;Inherit;False;Property;_NubeSuavidad;Nube Suavidad;6;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-455.4681,487.7197;Inherit;True;Property;_TexturaArena;Textura Arena;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-640.099,-481.0591;Inherit;False;Property;_ShadowThreshold;Shadow Threshold;16;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;-11.97231,417.4202;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;100;251.4265,306.5707;Inherit;False;781.2848;746.0025;Efecto de Arena Mojada;7;60;61;59;63;27;64;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;15;-900,-250;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;60;405.4262,809.5721;Inherit;False;Property;_NivelDelAgua;Nivel Del Agua;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;156.6284,191.418;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;174.9458,1775.334;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;99;-325.8391,-467.3963;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;325.4265,912.5721;Inherit;False;Property;_AnchoBandaMojada;Ancho Banda Mojada;19;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;88.28791,-68.09341;Inherit;False;Constant;_ShadowMult;ShadowMult;-1;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-600,-330;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;89;-152.3155,1504.604;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;174.9458,1875.334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;59;415.2281,647.152;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;315.9196,-176.987;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;19;-150,-330;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;69;396.0595,1793.12;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;606.4276,877.5721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;67;713.3608,1802.971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;566.8278,2042.364;Inherit;False;Property;_NubeIntensidad;Nube Intensidad;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;543.7432,356.5708;Inherit;False;Property;_TinteMojado;Tinte Mojado;20;0;Create;True;0;0;0;False;0;False;0.45,0.38,0.25,1;0.45,0.38,0.25,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;472,-52;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;94;919.2415,-931.4059;Inherit;False;748.1036;486.2089;Relieve;6;51;49;50;48;47;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;64;712.5729,697.8556;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;872.7117,600.3706;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;1023.566,-654.5544;Inherit;False;Property;_AlturaMinima;Altura Minima;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;1012.826,-569.3218;Inherit;False;Property;_AlturaMaxima;Altura Maxima;7;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;778.2581,1982.374;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;828.1819,139.545;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;46;969.2415,-881.4059;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;1688.088,404.7946;Inherit;False;Property;_Tesselletion;Tesselletion;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;1011.225,84.18353;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;49;1323.535,-837.1039;Inherit;False;Constant;_UpVector;UpVector;-1;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;76;915.83,1873.905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;1285.977,-604.1959;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1470.323,145.4523;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1505.344,-626.7971;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;44;1687.887,345.8948;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1822.042,-103.3469;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;Custom/ToonIsla;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;93;553.4832,1749.687;Inherit;False;653.0029;382.0594;Opacidad;0;;1,1,1,1;0;0
WireConnection;82;0;83;0
WireConnection;82;1;84;0
WireConnection;79;0;85;1
WireConnection;79;1;80;0
WireConnection;78;0;82;0
WireConnection;78;1;81;0
WireConnection;77;0;85;3
WireConnection;77;1;80;0
WireConnection;39;0;3;0
WireConnection;39;1;33;0
WireConnection;40;0;3;0
WireConnection;40;1;33;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;86;0;77;0
WireConnection;86;1;78;0
WireConnection;37;0;2;0
WireConnection;37;1;33;0
WireConnection;11;1;8;0
WireConnection;10;1;8;0
WireConnection;5;0;1;1
WireConnection;5;1;39;0
WireConnection;5;2;40;0
WireConnection;38;0;2;0
WireConnection;38;1;33;0
WireConnection;66;0;79;0
WireConnection;66;1;82;0
WireConnection;72;0;66;0
WireConnection;72;1;86;0
WireConnection;4;0;1;1
WireConnection;4;1;37;0
WireConnection;4;2;38;0
WireConnection;9;1;8;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;12;2;5;0
WireConnection;13;0;9;0
WireConnection;13;1;12;0
WireConnection;13;2;4;0
WireConnection;70;0;74;0
WireConnection;70;1;73;0
WireConnection;99;0;18;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;89;0;72;0
WireConnection;71;0;74;0
WireConnection;71;1;73;0
WireConnection;21;0;13;0
WireConnection;21;1;41;0
WireConnection;19;0;99;0
WireConnection;19;1;16;0
WireConnection;69;0;89;0
WireConnection;69;1;70;0
WireConnection;69;2;71;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;67;0;69;0
WireConnection;22;0;21;0
WireConnection;22;1;13;0
WireConnection;22;2;19;0
WireConnection;64;0;59;2
WireConnection;64;1;60;0
WireConnection;64;2;63;0
WireConnection;65;0;64;0
WireConnection;75;0;67;0
WireConnection;75;1;68;0
WireConnection;28;0;22;0
WireConnection;28;1;27;0
WireConnection;29;0;22;0
WireConnection;29;1;28;0
WireConnection;29;2;65;0
WireConnection;76;0;75;0
WireConnection;50;0;47;0
WireConnection;50;1;48;0
WireConnection;50;2;46;1
WireConnection;88;0;76;0
WireConnection;88;1;29;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;44;0;45;0
WireConnection;0;13;88;0
WireConnection;0;11;51;0
WireConnection;0;14;44;0
ASEEND*/
//CHKSM=9BEF89D85C6B9EA915F94D9DAA4740C5C65A00F5