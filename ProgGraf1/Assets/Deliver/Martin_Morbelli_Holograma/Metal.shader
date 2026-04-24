// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Metal"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_smoothnessMult("smoothnessMult", Range( 0 , 4)) = 1
		_androidTypo01_suit("androidTypo01_suit", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _androidTypo01_suit;
		uniform float4 _androidTypo01_suit_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _smoothnessMult;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_androidTypo01_suit = i.uv_texcoord * _androidTypo01_suit_ST.xy + _androidTypo01_suit_ST.zw;
			o.Normal = pow( tex2D( _androidTypo01_suit, uv_androidTypo01_suit ) , 8.0 ).rgb;
			float4 color3 = IsGammaSpace() ? float4(0.56,0.57,0.58,1) : float4(0.2738385,0.2846467,0.2956998,1);
			o.Albedo = color3.rgb;
			o.Metallic = 1.0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Smoothness = ( tex2D( _TextureSample0, uv_TextureSample0 ) * _smoothnessMult ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;590;1483.14;261.9234;1.469572;True;False
Node;AmplifyShaderEditor.SamplerNode;13;-904.2142,27.96319;Inherit;True;Property;_androidTypo01_suit;androidTypo01_suit;2;0;Create;True;0;0;0;False;0;False;-1;5cffb1b04f25f9e43aee736c74c5a193;5cffb1b04f25f9e43aee736c74c5a193;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-624.6437,222.218;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;14fbeebef2ed6094483d60b9041036bb;14fbeebef2ed6094483d60b9041036bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-503.6065,430.5005;Inherit;False;Property;_smoothnessMult;smoothnessMult;1;0;Create;True;0;0;0;False;0;False;1;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-579.343,-88.34809;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.56,0.57,0.58,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;6;-398.8721,84.99821;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;8;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-208.643,206.218;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-188.6253,126.5355;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Metal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;13;0
WireConnection;8;0;1;0
WireConnection;8;1;9;0
WireConnection;0;0;3;0
WireConnection;0;1;6;0
WireConnection;0;3;4;0
WireConnection;0;4;8;0
ASEEND*/
//CHKSM=5879DE895D6C7F59FF40E3566CF3753B18F179F7