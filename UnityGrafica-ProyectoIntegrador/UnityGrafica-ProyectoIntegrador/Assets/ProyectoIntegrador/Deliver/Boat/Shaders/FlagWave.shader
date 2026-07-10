// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/FlagWave"
{
	Properties
	{
		_MainTex("Albedo", 2D) = "white" {}
		_Amplitud("Amplitud", Range( 0 , 0.2)) = 0.01
		_Frecuencia("Frecuencia", Range( 0 , 30)) = 10
		_Velocidad("Velocidad", Range( 0 , 20)) = 8
		_EjeOnda("Eje Onda (normal bandera)", Vector) = (0,1,0,0)
		_MastX("Mastil X (local)", Float) = 0
		_MastScale("Mastil Escala", Float) = -50
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _MastX;
		uniform float _MastScale;
		uniform float _Frecuencia;
		uniform float _Velocidad;
		uniform float _Amplitud;
		uniform float3 _EjeOnda;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_6_0 = saturate( ( ( ase_vertex3Pos.x - _MastX ) * _MastScale ) );
			v.vertex.xyz += ( ( ( sin( ( ( temp_output_6_0 * _Frecuencia ) + ( _Time.y * _Velocidad ) ) ) * _Amplitud ) * temp_output_6_0 ) * _EjeOnda );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
235;73;1302;705;2497.161;832.7923;3.145442;True;False
Node;AmplifyShaderEditor.CommentaryNode;20;-1280.74,-235.1892;Inherit;False;747.5907;337.1097;Comment;6;6;1;2;3;5;4;Máscara distancia al mástil;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-1230.74,-185.1893;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1230.74,-25.18937;Inherit;False;Property;_MastX;Mastil X (local);5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1024.814,-14.07964;Inherit;False;Property;_MastScale;Mastil Escala;6;0;Create;True;0;0;0;False;0;False;-50;-50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1030.74,-125.1893;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-865.188,152.9652;Inherit;False;825.188;410.4425;Comment;7;9;11;12;13;7;10;8;Onda senoidal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-850.7401,-85.18935;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-815.188,447.4077;Inherit;False;Property;_Velocidad;Velocidad;3;0;Create;True;0;0;0;False;0;False;8;8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-698.1478,-60.00348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-803.3351,214.8152;Inherit;False;Property;_Frecuencia;Frecuencia;2;0;Create;True;0;0;0;False;0;False;10;10;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-710,340;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-511.1109,202.9652;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-520,360;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-340,220;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-324.8189,380.7411;Inherit;False;Property;_Amplitud;Amplitud;1;0;Create;True;0;0;0;False;0;False;0.01;0.01;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-190,220;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;22;29.25751,170;Inherit;False;472.7425;403.186;Comment;3;16;18;17;Desplazamiento sobre la normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-34.81524,313.335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;140,220;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;17;79.25751,385.1861;Inherit;False;Property;_EjeOnda;Eje Onda (normal bandera);4;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;19;140,-220;Inherit;True;Property;_MainTex;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;340,280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;620,-40;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/FlagWave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;1
WireConnection;3;1;2;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;12;0;8;0
WireConnection;12;1;11;0
WireConnection;13;0;12;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;16;0;15;0
WireConnection;16;1;6;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;0;0;19;0
WireConnection;0;11;18;0
ASEEND*/
//CHKSM=4D792FFB93226B7980B04C0D5E5E1ECB1335D168