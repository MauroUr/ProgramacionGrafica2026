// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Holograma"
{
	Properties
	{
		_Frequency("Frequency", Float) = 1
		_LinesSpeed("LinesSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _LinesSpeed;
		uniform float _Frequency;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0,0.6784314,1,1) : float4(0,0.4178852,1,1);
			float4 color2 = IsGammaSpace() ? float4(0,0.4290901,0.5283019,0.5882353) : float4(0,0.1541761,0.2411783,0.5882353);
			float mulTime9 = _Time.y * _LinesSpeed;
			float clampResult14 = clamp( sin( ( ( i.uv_texcoord.y + mulTime9 ) * ( _Frequency * 6.28318548202515 ) ) ) , 0.4 , 0.8 );
			float4 lerpResult3 = lerp( color1 , color2 , clampResult14);
			o.Albedo = lerpResult3.rgb;
			o.Alpha = clampResult14;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;590;1713.143;168.3362;1.674314;True;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-1055.708,386.3116;Inherit;False;Property;_LinesSpeed;LinesSpeed;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-963.1457,217.477;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TauNode;12;-832.5292,600.2634;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-890.4172,393.3213;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-901.5054,505.5837;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-702.1039,344.6183;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-712.1501,469.065;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-561.9863,384.9483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-435.3451,386.2955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-430.5,-125.5;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.6784314,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-430.5,49.5;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;0,0.4290901,0.5283019,0.5882353;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;14;-303.5892,381.422;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;-191.5,31.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Holograma;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;7;0
WireConnection;6;0;5;2
WireConnection;6;1;9;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;11;0;6;0
WireConnection;11;1;10;0
WireConnection;13;0;11;0
WireConnection;14;0;13;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;14;0
WireConnection;0;0;3;0
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=95FAB8ACAD26CB720852020EE9E826862BFCE459