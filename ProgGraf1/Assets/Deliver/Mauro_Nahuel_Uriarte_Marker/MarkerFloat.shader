// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MarkerFloat"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speedRotacion("speedRotacion", Float) = 2
		_emissionStrength("emissionStrength", Float) = 1
		_speedSubida("speedSubida", Float) = 2
		_oscilacionZ("oscilacionZ", Float) = 2
		_oscilacionX("oscilacionX", Float) = 2
		_AlturaMarker("AlturaMarker", Vector) = (0,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _speedSubida;
		uniform float3 _AlturaMarker;
		uniform float _oscilacionX;
		uniform float _oscilacionZ;
		uniform float _emissionStrength;
		uniform sampler2D _TextureSample0;
		uniform float _speedRotacion;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_56_0 = (0.0 + (sin( ( _Time.y * _speedSubida ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 rotatedValue31 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, float3( 0,0,1 ), ( sin( ( _Time.y * _oscilacionZ ) ) * 0.7 ) );
			float3 rotatedValue38 = RotateAroundAxis( float3( 0,0,0 ), rotatedValue31, float3( 1,0,0 ), ( sin( ( _Time.y * _oscilacionX ) ) * 0.7 ) );
			float smoothstepResult51 = smoothstep( 0.2 , _AlturaMarker.y , temp_output_56_0);
			v.vertex.xyz += ( ( temp_output_56_0 * ( _AlturaMarker * ( _AlturaMarker + ase_vertex3Pos ) ) ) + ( ( rotatedValue38 - ase_vertex3Pos ) * smoothstepResult51 ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color8 = IsGammaSpace() ? float4(1,0.5983629,0,0.3137255) : float4(1,0.3166394,0,0.3137255);
			o.Albedo = color8.rgb;
			o.Emission = ( color8 * _emissionStrength ).rgb;
			float cos12 = cos( ( _Time.y * _speedRotacion ) );
			float sin12 = sin( ( _Time.y * _speedRotacion ) );
			float2 rotator12 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos12 , -sin12 , sin12 , cos12 )) + float2( 0.5,0.5 );
			o.Alpha = ( color8.a * tex2D( _TextureSample0, rotator12 ).r );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;590;941.7128;419.4828;1.655804;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-1977.642,622.7413;Inherit;False;970.5513;501.7589;Oscilación eje Z;7;27;36;35;34;33;32;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1927.343,908.0032;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;-985.913,670;Inherit;False;937.913;563.9255;Oscilación eje X;6;38;40;39;41;43;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1927.642,1008.5;Inherit;False;Property;_oscilacionZ;oscilacionZ;4;0;Create;True;0;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-935.913,1022.546;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1181.376,286.9022;Inherit;False;1004.633;413.3978;Flotación (subida y bajada);8;47;48;49;19;25;29;56;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-874.299,1117.926;Inherit;False;Property;_oscilacionX;oscilacionX;5;0;Create;True;0;0;0;False;0;False;2;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1761.09,929.0333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1131.376,451.6658;Inherit;False;Property;_speedSubida;speedSubida;3;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-954.5909,373.7425;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-753.2253,958.1441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;35;-1617.462,912.2999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1487.091,848.7413;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1260.775,-296.8715;Inherit;False;1163.638;583.0886;Rotacion sobre su eje;8;8;18;9;11;7;12;6;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-779.593,366.7426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;39;-617.3264,938.1669;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;27;-1567.091,672.7413;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-496,864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1210.775,170.2172;Inherit;False;Property;_speedRotacion;speedRotacion;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1210.476,69.71993;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;25;-860.9537,484.1841;Inherit;False;Property;_AlturaMarker;AlturaMarker;6;0;Create;True;0;0;0;False;0;False;0,1,0;0,2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RotateAboutAxisNode;31;-1327.091,752.7413;Inherit;False;False;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;19;-514.2595,384.0169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-635.8826,565.3;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;56;-383.7429,336.9022;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1186.237,-102.1963;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1035.478,62.72002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-67.81301,255.4332;Inherit;False;573.6922;472.8119;Calculo final de vértices;5;46;26;54;51;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;38;-368,720;Inherit;False;False;4;0;FLOAT3;1,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotatorNode;12;-831.2883,-15.0661;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;80;2.745197,2.783512;Inherit;False;495.8094;278.7217;Emisión de color;2;58;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-17.81301,459.0367;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-467.8707,491.8138;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;51;42.38505,569.2451;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-581.3724,-43.737;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;5884620ae9000924caaf616d4c91a5b0;5884620ae9000924caaf616d4c91a5b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;187.3081,305.4332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;203.5711,453.933;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;8;-550.9812,-246.8714;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,0.5983629,0,0.3137255;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;52.7452,165.5052;Inherit;False;Property;_emissionStrength;emissionStrength;2;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;336.5546,52.78351;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;353.8792,310.2529;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-259.1375,-64.58157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;73;537.1207,-19.34917;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MarkerFloat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.3;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;41;0;43;0
WireConnection;41;1;42;0
WireConnection;35;0;34;0
WireConnection;36;0;35;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;39;0;41;0
WireConnection;40;0;39;0
WireConnection;31;1;36;0
WireConnection;31;3;27;0
WireConnection;19;0;49;0
WireConnection;29;0;25;0
WireConnection;29;1;27;0
WireConnection;56;0;19;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;38;1;40;0
WireConnection;38;3;31;0
WireConnection;12;0;7;0
WireConnection;12;2;11;0
WireConnection;44;0;38;0
WireConnection;44;1;27;0
WireConnection;30;0;25;0
WireConnection;30;1;29;0
WireConnection;51;0;56;0
WireConnection;51;2;25;2
WireConnection;6;1;12;0
WireConnection;26;0;56;0
WireConnection;26;1;30;0
WireConnection;54;0;44;0
WireConnection;54;1;51;0
WireConnection;58;0;8;0
WireConnection;58;1;57;0
WireConnection;46;0;26;0
WireConnection;46;1;54;0
WireConnection;18;0;8;4
WireConnection;18;1;6;1
WireConnection;73;0;8;0
WireConnection;73;2;58;0
WireConnection;73;9;18;0
WireConnection;73;11;46;0
ASEEND*/
//CHKSM=33EE2215B749DF1F07B386B5C792A2B81AE9B5C7