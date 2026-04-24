// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Piso"
{
	Properties
	{
		_pisoladrillos("pisoladrillos", 2D) = "white" {}
		_pisoladrillosNormal("pisoladrillosNormal", 2D) = "bump" {}
		_Color0("Color 0", Color) = (1,1,1,1)
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

		uniform sampler2D _pisoladrillosNormal;
		uniform float4 _pisoladrillosNormal_ST;
		uniform sampler2D _pisoladrillos;
		uniform float4 _pisoladrillos_ST;
		uniform float4 _Color0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_pisoladrillosNormal = i.uv_texcoord * _pisoladrillosNormal_ST.xy + _pisoladrillosNormal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _pisoladrillosNormal, uv_pisoladrillosNormal ) );
			float2 uv_pisoladrillos = i.uv_texcoord * _pisoladrillos_ST.xy + _pisoladrillos_ST.zw;
			o.Albedo = ( tex2D( _pisoladrillos, uv_pisoladrillos ) * _Color0 ).rgb;
			o.Metallic = 0.0;
			o.Smoothness = 0.1;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;590;1198.154;271.7849;1.184531;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-573.7985,-211.1545;Inherit;True;Property;_pisoladrillos;pisoladrillos;0;0;Create;True;0;0;0;False;0;False;-1;1fd68403c9f6ee84b8784e49676d191e;1fd68403c9f6ee84b8784e49676d191e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-514.1669,-15.89087;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-645.4722,160.1888;Inherit;True;Property;_pisoladrillosNormal;pisoladrillosNormal;1;0;Create;True;0;0;0;False;0;False;-1;3d5d330be27c5e549844f578a2c1f815;3d5d330be27c5e549844f578a2c1f815;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-190.5649,159.8131;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-182.5648,215.8131;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-185.8928,-120.2003;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Piso;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;6;0
WireConnection;0;0;5;0
WireConnection;0;1;2;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=B30AFB209F9FD0E64C539F830CC4B20204C34AAB