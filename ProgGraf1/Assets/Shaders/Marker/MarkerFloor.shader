// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Marker"
{
	Properties
	{
		_cfxraurarays("cfxr aura rays", 2D) = "white" {}
		_emissionStrength("emissionStrength", Float) = 1
		_speed("speed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _emissionStrength;
		uniform sampler2D _cfxraurarays;
		uniform float _speed;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color55 = IsGammaSpace() ? float4(1,0,0,0.5882353) : float4(1,0,0,0.5882353);
			o.Albedo = color55.rgb;
			o.Emission = ( color55 * _emissionStrength ).rgb;
			float cos60 = cos( ( _Time.y * _speed ) );
			float sin60 = sin( ( _Time.y * _speed ) );
			float2 rotator60 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos60 , -sin60 , sin60 , cos60 )) + float2( 0.5,0.5 );
			o.Alpha = tex2D( _cfxraurarays, rotator60 ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;727;997.0595;445.0983;1.176242;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;52;-758.4547,56.94039;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-758.7533,157.4369;Inherit;False;Property;_speed;speed;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-744.3872,250.6694;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-583.4559,49.94034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;60;-437.7414,108.9148;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;55;-427.744,-293.4926;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,0,0,0.5882353;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-404.2733,-98.77694;Inherit;False;Property;_emissionStrength;emissionStrength;1;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-231.0387,64.05193;Inherit;True;Property;_cfxraurarays;cfxr aura rays;0;0;Create;True;0;0;0;False;0;False;-1;aef6f9c943a864545ad9aa785233f8f5;aef6f9c943a864545ad9aa785233f8f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-189.6613,-126.1889;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;54;100.8135,-181.7375;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Marker;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;52;0
WireConnection;53;1;58;0
WireConnection;60;0;61;0
WireConnection;60;2;53;0
WireConnection;32;1;60;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;54;0;55;0
WireConnection;54;2;56;0
WireConnection;54;9;32;1
ASEEND*/
//CHKSM=C9660781EC809A35317B5BE69F0C12122ACB90E1