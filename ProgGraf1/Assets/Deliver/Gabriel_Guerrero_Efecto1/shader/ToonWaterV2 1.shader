// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ToonWaterV2"
{
	Properties
	{
		_TexturaAguaToon("Textura Agua (Toon)", 2D) = "white" {}
		_NubeEscala("Nube Escala", Float) = 50
		_FlowMapRXGY("Flow Map (R=X  G=Y)", 2D) = "gray" {}
		_NubeVelocidad("Nube Velocidad", Float) = 0.05
		_NubeUmbral("Nube Umbral", Range( 0 , 1)) = 0.5
		_PanDireccionXY("Pan Direccion (XY)", Vector) = (0.1,0.05,0,0)
		_PanSpeed("Pan Speed", Float) = 0.5
		_NubeSuavidad("Nube Suavidad", Range( 0 , 0.5)) = 0.15
		_PesoDistorsion("Peso Distorsion", Range( 0 , 0.5)) = 0.15
		_NubeIntensidad("Nube Intensidad", Range( 0 , 1)) = 0.5
		_EspumaBias("Espuma Bias", Range( 0.3 , 3)) = 0.5
		_EspumaScale("Espuma Scale", Range( 0.1 , 5)) = 1
		_EspumaPower("Espuma Power", Range( 1 , 10)) = 3
		_OleajeFrecuencia("Oleaje Frecuencia", Range( 0.1 , 10)) = 1
		_Tiling("Tiling", Float) = 2.49
		_OleajeVelocidad("Oleaje Velocidad", Range( 0.1 , 10)) = 1
		_OleajeAmplitud("Oleaje Amplitud", Range( 0 , 0.5)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _OleajeFrecuencia;
			uniform float _OleajeVelocidad;
			uniform float _OleajeAmplitud;
			uniform float _NubeUmbral;
			uniform float _NubeSuavidad;
			uniform float _NubeEscala;
			uniform float _NubeVelocidad;
			uniform float _NubeIntensidad;
			uniform sampler2D _TexturaAguaToon;
			uniform float2 _PanDireccionXY;
			uniform float _PanSpeed;
			uniform float _Tiling;
			uniform sampler2D _FlowMapRXGY;
			uniform float4 _FlowMapRXGY_ST;
			uniform float _PesoDistorsion;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _EspumaBias;
			uniform float _EspumaScale;
			uniform float _EspumaPower;
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 appendResult49 = (float3(0.0 , ( sin( ( ( ( ase_worldPos.x + ase_worldPos.z ) * _OleajeFrecuencia ) + ( _Time.y * _OleajeVelocidad ) ) ) * _OleajeAmplitud ) , 0.0));
				
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = appendResult49;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float temp_output_92_0 = ( _Time.y * _NubeVelocidad );
				float2 appendResult82 = (float2(( ( WorldPosition.x / _NubeEscala ) + temp_output_92_0 ) , ( ( WorldPosition.z / _NubeEscala ) + ( temp_output_92_0 * 0.5 ) )));
				float simplePerlin2D98 = snoise( appendResult82 );
				simplePerlin2D98 = simplePerlin2D98*0.5 + 0.5;
				float smoothstepResult78 = smoothstep( ( _NubeUmbral - _NubeSuavidad ) , ( _NubeUmbral + _NubeSuavidad ) , simplePerlin2D98);
				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord1 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float2 uv_FlowMapRXGY = i.ase_texcoord1.xy * _FlowMapRXGY_ST.xy + _FlowMapRXGY_ST.zw;
				float4 tex2DNode2 = tex2D( _FlowMapRXGY, uv_FlowMapRXGY );
				float2 appendResult5 = (float2(tex2DNode2.r , tex2DNode2.g));
				float2 lerpResult8 = lerp( texCoord1 , ( texCoord1 + appendResult5 ) , _PesoDistorsion);
				float2 panner12 = ( 1.0 * _Time.y * ( _PanDireccionXY * _PanSpeed ) + lerpResult8);
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth37 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth37 = abs( ( screenDepth37 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
				
				
				finalColor = ( ( 1.0 - ( ( 1.0 - smoothstepResult78 ) * _NubeIntensidad ) ) * saturate( ( tex2D( _TexturaAguaToon, panner12 ) + ( 1.0 - saturate( pow( ( ( distanceDepth37 + _EspumaBias ) * _EspumaScale ) , _EspumaPower ) ) ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
358;73;1141;567;1110.621;-369.3742;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;94;-3100.894,421.6813;Inherit;False;Property;_NubeVelocidad;Nube Velocidad;3;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;93;-3092.079,745.0396;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-3148.328,281.762;Inherit;False;Property;_NubeEscala;Nube Escala;1;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2847.651,667.4137;Inherit;False;Constant;_WindZ;WindZ;-1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2869.701,544.3879;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;95;-3050.538,63.01233;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;-1259.956,-38.86743;Inherit;False;Property;_Tiling;Tiling;14;0;Create;True;0;0;0;False;0;False;2.49;2.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1031.517,154.2721;Inherit;True;Property;_FlowMapRXGY;Flow Map (R=X  G=Y);2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-650,800;Inherit;False;Property;_EspumaBias;Espuma Bias;10;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;37;-678.4084,649.9656;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;87;-2785.477,334.9865;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;89;-2901.202,286.2374;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2667.252,584.7628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-400,650;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1033.454,-69.88125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-2397.925,206.4499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-2615.275,349.2385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-689.8074,185.7549;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-400,800;Inherit;False;Property;_EspumaScale;Espuma Scale;11;0;Create;True;0;0;0;False;0;False;1;1;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;38;-334.3325,1097.218;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;9;-600,-250;Inherit;False;Property;_PanDireccionXY;Pan Direccion (XY);5;0;Create;True;0;0;0;False;0;False;0.1,0.05;0.1,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-150,650;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-2276.299,280.9938;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-600,-100;Inherit;False;Property;_PanSpeed;Pan Speed;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-150,800;Inherit;False;Property;_EspumaPower;Espuma Power;12;0;Create;True;0;0;0;False;0;False;3;3;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-3235.127,524.1624;Inherit;False;Property;_NubeUmbral;Nube Umbral;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3217.801,615.4377;Inherit;False;Property;_NubeSuavidad;Nube Suavidad;7;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-401.6279,210.7844;Inherit;False;Property;_PesoDistorsion;Peso Distorsion;8;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-400,50;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-84.33261,1497.218;Inherit;False;Property;_OleajeVelocidad;Oleaje Velocidad;15;0;Create;True;0;0;0;False;0;False;1;1;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-84.33261,1097.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-84.33261,1397.218;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-1891.264,475.0632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-84.33261,1247.218;Inherit;False;Property;_OleajeFrecuencia;Oleaje Frecuencia;13;0;Create;True;0;0;0;False;0;False;1;1;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-2084.706,102.1242;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;100,650;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-350,-180;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;79;-1891.264,375.0628;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-200,0;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;78;-1657.22,522.5482;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;115.6673,1427.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;115.6673,1147.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;1.125102,-50;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;50;160.8088,553.2108;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2265.362,622.8242;Inherit;False;Property;_NubeIntensidad;Nube Intensidad;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;315.6674,1247.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;274.8643,-63.02417;Inherit;True;Property;_TexturaAguaToon;Textura Agua (Toon);0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;22;291.5977,648.3195;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;76;-1401.22,522.5482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;550,250;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1336.323,701.9496;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;46;515.6674,1247.218;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;515.6674,1397.218;Inherit;False;Property;_OleajeAmplitud;Oleaje Amplitud;16;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;770.5998,253.8625;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;86;-1198.751,593.4818;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;715.6674,1247.218;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;806.6174,348.794;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;81;-2141.265,325.0633;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.DynamicAppendNode;49;915.6674,1247.218;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;34;947.2962,254.4062;Float;False;True;-1;2;ASEMaterialInspector;100;1;Custom/ToonWaterV2;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;92;0;93;0
WireConnection;92;1;94;0
WireConnection;87;0;95;3
WireConnection;87;1;90;0
WireConnection;89;0;95;1
WireConnection;89;1;90;0
WireConnection;88;0;92;0
WireConnection;88;1;91;0
WireConnection;17;0;37;0
WireConnection;17;1;16;0
WireConnection;1;0;36;0
WireConnection;96;0;87;0
WireConnection;96;1;88;0
WireConnection;75;0;89;0
WireConnection;75;1;92;0
WireConnection;5;0;2;1
WireConnection;5;1;2;2
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;82;0;75;0
WireConnection;82;1;96;0
WireConnection;6;0;1;0
WireConnection;6;1;5;0
WireConnection;39;0;38;1
WireConnection;39;1;38;3
WireConnection;80;0;84;0
WireConnection;80;1;83;0
WireConnection;98;0;82;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;79;0;84;0
WireConnection;79;1;83;0
WireConnection;8;0;1;0
WireConnection;8;1;6;0
WireConnection;8;2;7;0
WireConnection;78;0;98;0
WireConnection;78;1;79;0
WireConnection;78;2;80;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;12;0;8;0
WireConnection;12;2;11;0
WireConnection;50;0;21;0
WireConnection;45;0;41;0
WireConnection;45;1;44;0
WireConnection;13;1;12;0
WireConnection;22;0;50;0
WireConnection;76;0;78;0
WireConnection;23;0;13;0
WireConnection;23;1;22;0
WireConnection;85;0;76;0
WireConnection;85;1;77;0
WireConnection;46;0;45;0
WireConnection;24;0;23;0
WireConnection;86;0;85;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;97;0;86;0
WireConnection;97;1;24;0
WireConnection;81;0;82;0
WireConnection;49;1;48;0
WireConnection;34;0;97;0
WireConnection;34;1;49;0
ASEEND*/
//CHKSM=34FCA75DAF6F11FC6C2F1A2A851DBD60202A9D7C