// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fantasmin"
{
	Properties
	{
		_FloatSpeed("Float Speed", Float) = 1
		_GhostColor("Ghost Color", Color) = (0.4,0.9,1,1)
		_FresnelPower("Fresnel Power", Float) = 2
		_SprayTex("SprayTex", 2D) = "white" {}
		_FloatAmplitude("FloatAmplitude", Float) = 0.1
		_VelocidadSpray("Velocidad Spray", Float) = 1
		_VelocidadCurva("Velocidad Curva", Float) = 2
		_AmplitudCurva("Amplitud Curva", Float) = 0.5
		_FuerzaDistorsion("Fuerza Distorsion", Float) = 0.1
		_SprayColor("SprayColor", Color) = (1,1,1,1)
		_EscalaEstrellas("EscalaEstrellas", Vector) = (1,1,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_VelocidadEstrellas("VelocidadEstrellas", Vector) = (1,1,0,0)
		_Vector0("Vector 0", Vector) = (1,0,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float3 _Vector0;
		uniform float _FloatSpeed;
		uniform float _FloatAmplitude;
		uniform sampler2D _TextureSample0;
		uniform float2 _VelocidadEstrellas;
		uniform float2 _EscalaEstrellas;
		uniform float _FresnelPower;
		uniform sampler2D _SprayTex;
		uniform float _VelocidadCurva;
		uniform float _AmplitudCurva;
		uniform float _VelocidadSpray;
		uniform float _FuerzaDistorsion;
		uniform float4 _GhostColor;
		uniform float4 _SprayColor;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult37 = (float2(0.0 , ( sin( ( _Time.y * _FloatSpeed ) ) * _FloatAmplitude )));
			v.vertex.xyz += ( ( ( sin( ( _Time.y + ase_vertex3Pos.z ) ) * _Vector0 ) * (1.0 + (ase_vertex3Pos.y - -1.0) * (0.0 - 1.0) / (1.0 - -1.0)) ) + float3( appendResult37 ,  0.0 ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 panner58 = ( 1.0 * _Time.y * _VelocidadEstrellas + ( (ase_screenPosNorm).xy / _EscalaEstrellas ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV9 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode9 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV9, _FresnelPower ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_14_0 = ( _Time.y * _VelocidadSpray );
			float2 appendResult25 = (float2(( ( ase_vertex3Pos.x + ( sin( ( _Time.y * _VelocidadCurva ) ) * _AmplitudCurva ) ) + sin( ( floor( temp_output_14_0 ) * 0.3 ) ) ) , ( ase_vertex3Pos.y + (-2.5 + (frac( temp_output_14_0 ) - 0.0) * (1.0 - -2.5) / (1.0 - 0.0)) )));
			float simplePerlin2D29 = snoise( float2( 0,0 ) );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float4 tex2DNode35 = tex2D( _SprayTex, ( ( appendResult25 + ( simplePerlin2D29 * _FuerzaDistorsion ) ) / (0.5 + (sin( _Time.y ) - -1.0) * (1.5 - 0.5) / (1.0 - -1.0)) ) );
			float temp_output_32_0 = saturate( ( fresnelNode9 + tex2DNode35.a ) );
			float4 lerpResult30 = lerp( ( _GhostColor * fresnelNode9 ) , ( _SprayColor * tex2DNode35 ) , tex2DNode35.a);
			o.Emission = ( ( tex2D( _TextureSample0, panner58 ) * temp_output_32_0 ) + lerpResult30 ).rgb;
			o.Alpha = temp_output_32_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
390;73;1163;719;681.5945;669.1103;1.18146;True;False
Node;AmplifyShaderEditor.CommentaryNode;72;-2124.987,555.4488;Inherit;False;1528.853;672.9089;Mivimiento del Spray;23;17;15;14;16;26;19;40;18;38;41;39;42;29;43;12;28;25;27;24;22;20;21;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2071.208,929.5992;Inherit;False;Property;_VelocidadSpray;Velocidad Spray;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2362.425,129.5221;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2074.987,1096.446;Inherit;False;Property;_VelocidadCurva;Velocidad Curva;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2020.21,835.5997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2022.72,1012.415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;26;-1872.915,1017.359;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1729.915,1112.359;Inherit;False;Property;_AmplitudCurva;Amplitud Curva;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;40;-1880.353,722.9633;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-2015.969,405.2857;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1729.915,1016.359;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1772.056,729.1908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;38;-1882.253,835.9075;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1479.932,605.4493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-1702.891,842.993;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-2.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;42;-1656.666,726.2277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-1221.329,902.2972;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1323.802,695.4653;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1473.451,806.7014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1075.063,991.377;Inherit;False;Property;_FuerzaDistorsion;Fuerza Distorsion;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1263.538,804.404;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;21;-2121.985,1171.457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1018.135,906.4503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1279.708,-1073.116;Inherit;False;1163.667;412.0145;Fondo Estrellado;7;54;57;55;56;59;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1763.563,-243.4884;Inherit;False;765.0927;262.8505;Floating speed and Amplitude;6;36;6;5;4;3;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-879.0341,809.9727;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;54;-1229.708,-1023.116;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1;-1714.438,-625.9865;Inherit;False;713.6796;354.3065;Fresnel;4;10;9;8;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;23;-1388.654,1174.277;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;-1798.3,90.08624;Inherit;False;901.7849;341.5739;Ondulacion de la malla;6;64;65;66;67;68;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1564.858,-391.1023;Inherit;False;Property;_FresnelPower;Fresnel Power;2;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1713.563,-99.72624;Inherit;False;Property;_FloatSpeed;Float Speed;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;57;-991.1924,-884.0785;Inherit;False;Property;_EscalaEstrellas;EscalaEstrellas;10;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-748.1354,909.4503;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;55;-1009.142,-982.8004;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;59;-711.4663,-837.1017;Inherit;False;Property;_VelocidadEstrellas;VelocidadEstrellas;12;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;9;-1382.372,-478.68;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-572.233,573.9431;Inherit;True;Property;_SprayTex;SprayTex;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1748.3,140.0862;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1684.941,-183.082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;56;-793.7483,-980.2362;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;66;-1610.946,221.0483;Inherit;False;Property;_Vector0;Vector 0;13;0;Create;True;0;0;0;False;0;False;1,0,1;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-376.5669,-440.076;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1664.438,-575.9865;Inherit;False;Property;_GhostColor;Ghost Color;1;0;Create;True;0;0;0;False;0;False;0.4,0.9,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-560.9174,385.2567;Inherit;False;Property;_SprayColor;SprayColor;9;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;6;-1514.223,-182.1393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;65;-1609.794,141.5618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1393.469,-96.63791;Inherit;False;Property;_FloatAmplitude;FloatAmplitude;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;58;-612.9717,-980.2362;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-240.4893,390.5429;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-436.0411,-1003.314;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1447.515,141.6602;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;-1293.515,224.6601;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-235.1887,-444.1053;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1350.855,-180.8175;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1143.873,-563.369;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1058.515,143.6602;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;30;-64.80175,-356.7054;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-43.06169,-662.6504;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-1125.759,-202.1809;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;118.1215,-553.4688;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-806.3364,-12.99191;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;238.9428,-602.1359;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Fantasmin;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;11;0
WireConnection;14;1;15;0
WireConnection;16;0;11;0
WireConnection;16;1;17;0
WireConnection;26;0;16;0
WireConnection;40;0;14;0
WireConnection;18;0;26;0
WireConnection;18;1;19;0
WireConnection;41;0;40;0
WireConnection;38;0;14;0
WireConnection;20;0;13;1
WireConnection;20;1;18;0
WireConnection;39;0;38;0
WireConnection;42;0;41;0
WireConnection;43;0;20;0
WireConnection;43;1;42;0
WireConnection;12;0;13;2
WireConnection;12;1;39;0
WireConnection;25;0;43;0
WireConnection;25;1;12;0
WireConnection;21;0;11;0
WireConnection;27;0;29;0
WireConnection;27;1;28;0
WireConnection;24;0;25;0
WireConnection;24;1;27;0
WireConnection;23;0;21;0
WireConnection;22;0;24;0
WireConnection;22;1;23;0
WireConnection;55;0;54;0
WireConnection;9;3;10;0
WireConnection;35;1;22;0
WireConnection;64;0;11;0
WireConnection;64;1;13;3
WireConnection;3;0;11;0
WireConnection;3;1;5;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;31;0;9;0
WireConnection;31;1;35;4
WireConnection;6;0;3;0
WireConnection;65;0;64;0
WireConnection;58;0;56;0
WireConnection;58;2;59;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;60;1;58;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;68;0;13;2
WireConnection;32;0;31;0
WireConnection;4;0;6;0
WireConnection;4;1;36;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;30;0;8;0
WireConnection;30;1;33;0
WireConnection;30;2;35;4
WireConnection;61;0;60;0
WireConnection;61;1;32;0
WireConnection;37;1;4;0
WireConnection;62;0;61;0
WireConnection;62;1;30;0
WireConnection;70;0;69;0
WireConnection;70;1;37;0
WireConnection;0;2;62;0
WireConnection;0;9;32;0
WireConnection;0;11;70;0
ASEEND*/
//CHKSM=60889B1E7CC8652876476B775940EBE8B282CA16