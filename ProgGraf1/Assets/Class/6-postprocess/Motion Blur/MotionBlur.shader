// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MotionBlur"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Movement("Movement", Vector) = (0.1,0.1,0,0)
		_Strenght("Strenght", Float) = 0
		_camForward("camForward", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _Movement;
			uniform float _Strenght;
			uniform float3 _camForward;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv46 = uv_MainTex;
				float2 movement53 = _Movement;
				float strenght50 = _Strenght;
				float dotResult28 = dot( float3( movement53 ,  0.0 ) , _camForward );
				float2 lerpResult56 = lerp( ( uv46 + ( movement53 * strenght50 ) ) , ( uv46 + ( ( uv46 - float2( 0.5,0.5 ) ) * ( strenght50 * -1.0 ) ) ) , ( 1.0 - dotResult28 ));
				

				finalColor = saturate( ( ( tex2D( _MainTex, uv_MainTex ) * float4( 0.75,0.75,0.75,0.7490196 ) ) + ( tex2D( _MainTex, lerpResult56 ) * float4( 0.25,0.25,0.25,0.2509804 ) ) ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
259;-1007;1337;577;2965.092;110.9245;1.250575;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-2606.413,-418.2179;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2394.505,-437.1163;Inherit;False;screen;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-2910.269,-271.6297;Inherit;False;42;screen;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2697.005,-271.5437;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-2637.286,-92.20811;Inherit;False;Property;_Strenght;Strenght;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2400.172,-273.4204;Inherit;False;uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;8;-2659.65,84.14236;Inherit;False;Property;_Movement;Movement;0;0;Create;True;0;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;41;-1988.352,280.5848;Inherit;False;562.8658;321;center;6;37;34;33;48;52;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2427.227,-112.4365;Inherit;False;strenght;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2170.27,384.0648;Inherit;False;46;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-2045.928,508.2688;Inherit;False;50;strenght;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2454.806,68.27394;Inherit;False;movement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1995.45,-179.287;Inherit;False;584.0023;434.9998;lateral;5;16;15;47;51;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-1938.352,384.6773;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1941.876,25.78272;Inherit;False;53;movement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;57;-1634.166,743.7689;Inherit;False;Property;_camForward;camForward;2;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1946.165,151.6159;Inherit;False;50;strenght;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1635.789,632.6403;Inherit;False;53;movement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1880.844,510.6112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1748.487,466.5844;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1873.325,-88.15578;Inherit;False;46;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1728.79,360.4017;Inherit;False;46;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;28;-1350.833,691.0013;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1726.45,66.7126;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1563.447,-31.28713;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1552.044,381.4758;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;30;-1181.371,692.9209;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-821.5457,-192.4813;Inherit;False;42;screen;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;56;-1002.481,214.9836;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-761.46,101.5094;Inherit;False;42;screen;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;6;-564,121.5;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-551,-139.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-204,-63.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.75,0.75,0.75,0.7490196;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-196,163.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.25,0.25,0.25,0.2509804;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;20,15.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;182,5.5;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;328,-6;Float;False;True;-1;2;ASEMaterialInspector;0;2;MotionBlur;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;42;0;1;0
WireConnection;14;2;45;0
WireConnection;46;0;14;0
WireConnection;50;0;17;0
WireConnection;53;0;8;0
WireConnection;37;0;49;0
WireConnection;59;0;52;0
WireConnection;34;0;37;0
WireConnection;34;1;59;0
WireConnection;28;0;55;0
WireConnection;28;1;57;0
WireConnection;16;0;54;0
WireConnection;16;1;51;0
WireConnection;15;0;47;0
WireConnection;15;1;16;0
WireConnection;33;0;48;0
WireConnection;33;1;34;0
WireConnection;30;0;28;0
WireConnection;56;0;15;0
WireConnection;56;1;33;0
WireConnection;56;2;30;0
WireConnection;6;0;44;0
WireConnection;6;1;56;0
WireConnection;2;0;43;0
WireConnection;4;0;2;0
WireConnection;7;0;6;0
WireConnection;13;0;4;0
WireConnection;13;1;7;0
WireConnection;11;0;13;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=E679CFD12ED918E09ECE1E97A948B9D345A2BAFC