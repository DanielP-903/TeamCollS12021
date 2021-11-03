// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PPS/Outline"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_SampleStep("SampleStep", Float) = 1
		_MaxDepth("MaxDepth", Float) = 5000
		_DepthMulti1("DepthMulti", Range( 0 , 1)) = 450
		_DepthPower1("DepthPower", Range( 0 , 1)) = 10
		_OutlineColor("Outline Color", Color) = (0.9245283,0.738364,0.248576,0)
		_DepthOutlineThreshold("Depth Outline Threshold", Range( 0 , 10)) = 0
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
			
			uniform float4 _OutlineColor;
			uniform float _DepthOutlineThreshold;
			uniform sampler2D _CameraDepthNormalsTexture;
			uniform float _MaxDepth;
			uniform float _SampleStep;
			uniform float _DepthMulti1;
			uniform float _DepthPower1;


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
				float DepthOutlineThreshold313 = ( _DepthOutlineThreshold * 0.0001 );
				float2 texCoord93 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 localCenter52 = texCoord93;
				float depthDecodedVal108 = 0;
				float3 normalDecodedVal108 = float3(0,0,0);
				DecodeDepthNormal( tex2D( _CameraDepthNormalsTexture, localCenter52 ), depthDecodedVal108, normalDecodedVal108 );
				float MaxDepth96 = _MaxDepth;
				float clampResult109 = clamp( depthDecodedVal108 , 0.0 , MaxDepth96 );
				float centerDepth182 = clampResult109;
				float4 break8 = ( _MainTex_TexelSize * _SampleStep );
				float localStepY31 = break8.y;
				float2 appendResult100 = (float2(0.0 , localStepY31));
				float depthDecodedVal89 = 0;
				float3 normalDecodedVal89 = float3(0,0,0);
				DecodeDepthNormal( tex2D( _CameraDepthNormalsTexture, ( localCenter52 + appendResult100 ) ), depthDecodedVal89, normalDecodedVal89 );
				float clampResult111 = clamp( depthDecodedVal89 , 0.0 , MaxDepth96 );
				float temp_output_195_0 = ( centerDepth182 - clampResult111 );
				float localStepX33 = break8.x;
				float2 appendResult115 = (float2(localStepX33 , 0.0));
				float depthDecodedVal121 = 0;
				float3 normalDecodedVal121 = float3(0,0,0);
				DecodeDepthNormal( tex2D( _CameraDepthNormalsTexture, ( localCenter52 + appendResult115 ) ), depthDecodedVal121, normalDecodedVal121 );
				float clampResult119 = clamp( depthDecodedVal121 , 0.0 , MaxDepth96 );
				float temp_output_201_0 = ( centerDepth182 - clampResult119 );
				float localNegStepY38 = -break8.y;
				float2 appendResult124 = (float2(0.0 , localNegStepY38));
				float depthDecodedVal130 = 0;
				float3 normalDecodedVal130 = float3(0,0,0);
				DecodeDepthNormal( tex2D( _CameraDepthNormalsTexture, ( localCenter52 + appendResult124 ) ), depthDecodedVal130, normalDecodedVal130 );
				float clampResult128 = clamp( depthDecodedVal130 , 0.0 , MaxDepth96 );
				float temp_output_199_0 = ( centerDepth182 - clampResult128 );
				float localNegStepX69 = -break8.x;
				float2 appendResult133 = (float2(localNegStepX69 , 0.0));
				float depthDecodedVal139 = 0;
				float3 normalDecodedVal139 = float3(0,0,0);
				DecodeDepthNormal( tex2D( _CameraDepthNormalsTexture, ( localCenter52 + appendResult133 ) ), depthDecodedVal139, normalDecodedVal139 );
				float clampResult137 = clamp( depthDecodedVal139 , 0.0 , MaxDepth96 );
				float temp_output_197_0 = ( centerDepth182 - clampResult137 );
				float DepthMask284 = saturate( ( step( DepthOutlineThreshold313 , temp_output_195_0 ) + step( DepthOutlineThreshold313 , temp_output_201_0 ) + step( DepthOutlineThreshold313 , temp_output_199_0 ) + step( DepthOutlineThreshold313 , temp_output_197_0 ) ) );
				float4 lerpResult304 = lerp( _OutlineColor , tex2D( _MainTex, uv_MainTex ) , saturate( ( 1.0 - pow( ( DepthMask284 * _DepthMulti1 ) , _DepthPower1 ) ) ));
				

				finalColor = lerpResult304;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
0;30.66667;1706.667;1015;1285.576;709.0977;1.483175;True;False
Node;AmplifyShaderEditor.CommentaryNode;94;-910.6166,-885.847;Inherit;False;1244.192;635.7679;Comment;16;31;7;26;5;8;93;6;69;33;38;51;52;96;95;187;188;Setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;5;-860.6166,-804.1901;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-785.3668,-617.8393;Inherit;False;Property;_SampleStep;SampleStep;0;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-574.5114,-702.5589;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-414.0539,-701.5589;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-139.4089,-409.0791;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;26;-34.99506,-717.8469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;187;-625.9219,-544.5728;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NegateNode;51;-28.758,-508.6807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-42.758,-626.6808;Inherit;False;localStepY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;109.241,-513.6807;Inherit;False;localNegStepY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;103.004,-722.8469;Inherit;False;localNegStepX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-48.99506,-835.847;Inherit;False;localStepX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-302.0383,-545.7268;Inherit;False;DepthNormalsTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;109.575,-413.6807;Inherit;False;localCenter;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;559.1342,-1008.206;Inherit;False;31;localStepY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;602.1347,-181.3391;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;584.0782,-551.0709;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;743.3614,-1456.726;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;176;581.8151,-1086.968;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;545.0889,-450.9639;Inherit;False;38;localNegStepY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;566.5521,-270.9055;Inherit;False;69;localNegStepX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;559.8954,-814.8918;Inherit;False;33;localStepX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-887.3156,-358.4974;Inherit;False;Property;_MaxDepth;MaxDepth;1;0;Create;True;0;0;0;False;0;False;5000;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;586.678,-734.3762;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;716.2137,-1545.443;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-719.1699,-357.4964;Inherit;False;MaxDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;713.639,-1171.412;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;747.8225,-785.3129;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;748.7633,-1062.177;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;107;991.509,-1497.338;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;133;758.3789,-245.2265;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;708.6939,-628.47;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;743.8182,-519.235;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;723.2545,-354.4615;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;712.6982,-894.5479;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;853.824,-970.2537;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;959.5685,-350.5116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;108;1325.596,-1492.375;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.GetLocalVarNode;110;1579.837,-1379.428;Inherit;False;96;MaxDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;886.0131,-430.0415;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;949.9529,-1167.461;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;856.623,-704.3461;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;828.1262,-1271.238;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;945.0078,-624.52;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;949.0122,-890.598;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;127;1110.582,-652.5549;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;1;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;109;1773.963,-1492.229;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-781.8898,-196.198;Inherit;True;Property;_DepthOutlineThreshold;Depth Outline Threshold;8;0;Create;True;0;0;0;False;0;False;0;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;118;1114.586,-918.6329;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;136;1125.143,-378.5465;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;88;1081.996,-1196.982;Inherit;True;Global;_TextureSample0;_CameraDepthNormalsTexture;1;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;1735.874,-533.5449;Inherit;False;96;MaxDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;1740.821,-1076.487;Inherit;False;96;MaxDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;130;1475.899,-648.1429;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.GetLocalVarNode;120;1739.881,-799.6229;Inherit;False;96;MaxDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;-496.0372,-189.3535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;121;1479.906,-914.2209;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.DecodeDepthNormalNode;139;1490.462,-374.1345;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;2005.77,-1497.206;Inherit;False;centerDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;89;1479.762,-1191.07;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.GetLocalVarNode;138;1750.437,-259.5365;Inherit;False;96;MaxDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;2030.6,-1278.955;Inherit;False;182;centerDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;137;1928.437,-373.5365;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;111;1918.82,-1190.487;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;2036.824,-470.8864;Inherit;False;182;centerDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;119;1917.88,-913.6229;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;2031.824,-732.8864;Inherit;False;182;centerDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-329.8561,-194.2317;Inherit;False;DepthOutlineThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;2035.824,-999.8864;Inherit;False;182;centerDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;128;1913.874,-647.5449;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;2132.742,-1416.938;Inherit;False;313;DepthOutlineThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;195;2225.048,-1214.817;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;197;2229.272,-393.7484;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;2181.463,-830.3535;Inherit;False;313;DepthOutlineThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;201;2230.272,-935.7484;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;2142.963,-1142.354;Inherit;False;313;DepthOutlineThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;199;2226.272,-668.7484;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;2260.463,-548.3535;Inherit;False;313;DepthOutlineThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;315;2380.742,-1412.938;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;320;2448.463,-834.3535;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;322;2527.463,-552.3535;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;318;2409.963,-1146.354;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;2700.553,-837.6639;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;296;2894.612,-837.5791;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;3100.207,-842.2505;Inherit;False;DepthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;2766.783,1.888313;Inherit;True;284;DepthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;2992.231,165.6932;Inherit;False;Property;_DepthMulti1;DepthMulti;4;0;Create;True;0;0;0;False;0;False;450;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;3053.976,6.987122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;3267.231,164.6932;Inherit;False;Property;_DepthPower1;DepthPower;6;0;Create;True;0;0;0;False;0;False;10;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;283;3341.231,10.69421;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;308;3495.052,-193.9071;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;302;3556.783,11.88831;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;298;3690.218,-387.7812;Inherit;False;Property;_OutlineColor;Outline Color;7;0;Create;True;0;0;0;False;0;False;0.9245283,0.738364,0.248576,0;1,0.6179245,0.6295035,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;303;3752.783,10.88831;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;309;3643.052,-198.9071;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;271;2163.566,658.1379;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;285;3270.876,1049.336;Inherit;False;NormalMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;2921.384,1053.168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;1817.24,873.5148;Inherit;False;251;centerNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;809.1674,958.0349;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;269;2010.686,1479.653;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;243;1422.065,360.2078;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;1733.24,378.3768;Inherit;False;centerNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;232;805.163,1224.113;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;1812.152,1140.515;Inherit;False;251;centerNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;240;1045.482,961.9849;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;304;3996.783,-234.1117;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;220;678.2843,765.6147;Inherit;False;Constant;_Float5;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;207;2388.553,-667.4645;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;248;1211.056,933.9501;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;270;2011.686,937.6526;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;206;2390.954,-393.8638;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;227;844.2916,1067.27;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;950.2931,882.3291;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;641.558,1401.619;Inherit;False;38;localNegStepY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;656.3646,1037.691;Inherit;False;33;localStepX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;276;2574.992,1052.042;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;310;2651.214,963.5155;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;1818.24,1402.515;Inherit;False;251;centerNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;225;683.1471,1118.206;Inherit;False;Constant;_Float7;Float 1;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;205;2382.152,-1215.263;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;247;1221.612,1474.036;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;224;812.6827,307.1398;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;249;1207.051,1200.028;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;1;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;213;3092.639,1053.875;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;277;2725.159,1052.071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;3019.639,1223.875;Inherit;False;Property;_NormalPower;NormalPower;5;0;Create;True;0;0;0;False;0;False;40;-8.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;246;1178.465,655.6006;Inherit;True;Global;_TextureSample0;_CameraDepthNormalsTexture;1;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;230;1087.978,355.2449;Inherit;True;Global;_CameraDepthNormalsTexture;_CameraDepthNormalsTexture;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;222;680.5472,1301.512;Inherit;False;Constant;_Float6;Float 2;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;663.0214,1581.677;Inherit;False;69;localNegStepX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;1812.016,594.4459;Inherit;False;251;centerNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;839.8304,395.8568;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;268;2006.462,658.5839;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;214;2778.639,1221.875;Inherit;False;Property;_NormalMulti;NormalMulti;3;0;Create;True;0;0;0;False;0;False;2;-6.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;267;2007.686,1204.653;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;275;2415.132,1063.305;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;219;698.6039,1671.244;Inherit;False;Constant;_Float4;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;228;840.2872,1333.348;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;1041.477,1228.063;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;655.6034,844.377;Inherit;False;31;localStepY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;244;1056.038,1502.071;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;208;2386.75,-935.6634;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;257;1576.375,938.3621;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.DynamicAppendNode;233;845.2325,790.4058;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;253;1572.368,1204.44;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.GetLocalVarNode;236;982.4823,1422.541;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;924.5953,581.3447;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;239;953.0922,1148.237;Inherit;False;188;DepthNormalsTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;258;1576.231,661.5128;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.AbsOpNode;274;2172.368,1479.538;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;229;854.848,1607.356;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;256;1586.931,1478.448;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.AbsOpNode;272;2168.164,937.7377;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;231;810.108,681.1707;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;234;819.7238,1498.121;Inherit;False;52;localCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;1046.422,685.1216;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;273;2172.743,1204.549;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;4206.278,-234.1668;Float;False;True;-1;2;ASEMaterialInspector;0;2;PPS/Outline;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;0;7;0
WireConnection;26;0;8;0
WireConnection;51;0;8;1
WireConnection;31;0;8;1
WireConnection;38;0;51;0
WireConnection;69;0;26;0
WireConnection;33;0;8;0
WireConnection;188;0;187;0
WireConnection;52;0;93;0
WireConnection;96;0;95;0
WireConnection;115;0;114;0
WireConnection;115;1;177;0
WireConnection;100;0;176;0
WireConnection;100;1;102;0
WireConnection;107;0;189;0
WireConnection;107;1;105;0
WireConnection;133;0;132;0
WireConnection;133;1;179;0
WireConnection;124;0;178;0
WireConnection;124;1;122;0
WireConnection;135;0;134;0
WireConnection;135;1;133;0
WireConnection;108;0;107;0
WireConnection;103;0;97;0
WireConnection;103;1;100;0
WireConnection;126;0;125;0
WireConnection;126;1;124;0
WireConnection;117;0;116;0
WireConnection;117;1;115;0
WireConnection;127;0;192;0
WireConnection;127;1;126;0
WireConnection;109;0;108;0
WireConnection;109;2;110;0
WireConnection;118;0;191;0
WireConnection;118;1;117;0
WireConnection;136;0;193;0
WireConnection;136;1;135;0
WireConnection;88;0;190;0
WireConnection;88;1;103;0
WireConnection;130;0;127;0
WireConnection;323;0;312;0
WireConnection;121;0;118;0
WireConnection;139;0;136;0
WireConnection;182;0;109;0
WireConnection;89;0;88;0
WireConnection;137;0;139;0
WireConnection;137;2;138;0
WireConnection;111;0;89;0
WireConnection;111;2;112;0
WireConnection;119;0;121;0
WireConnection;119;2;120;0
WireConnection;313;0;323;0
WireConnection;128;0;130;0
WireConnection;128;2;129;0
WireConnection;195;0;194;0
WireConnection;195;1;111;0
WireConnection;197;0;196;0
WireConnection;197;1;137;0
WireConnection;201;0;200;0
WireConnection;201;1;119;0
WireConnection;199;0;198;0
WireConnection;199;1;128;0
WireConnection;315;0;314;0
WireConnection;315;1;195;0
WireConnection;320;0;319;0
WireConnection;320;1;199;0
WireConnection;322;0;321;0
WireConnection;322;1;197;0
WireConnection;318;0;317;0
WireConnection;318;1;201;0
WireConnection;202;0;315;0
WireConnection;202;1;318;0
WireConnection;202;2;320;0
WireConnection;202;3;322;0
WireConnection;296;0;202;0
WireConnection;284;0;296;0
WireConnection;281;0;300;0
WireConnection;281;1;279;0
WireConnection;283;0;281;0
WireConnection;283;1;282;0
WireConnection;302;0;283;0
WireConnection;303;0;302;0
WireConnection;309;0;308;0
WireConnection;271;0;268;0
WireConnection;285;0;213;0
WireConnection;212;0;310;0
WireConnection;212;1;214;0
WireConnection;269;0;260;0
WireConnection;269;1;256;1
WireConnection;243;0;230;0
WireConnection;251;0;243;1
WireConnection;240;0;226;0
WireConnection;240;1;227;0
WireConnection;304;0;298;0
WireConnection;304;1;309;0
WireConnection;304;2;303;0
WireConnection;207;0;199;0
WireConnection;248;0;241;0
WireConnection;248;1;240;0
WireConnection;270;0;262;0
WireConnection;270;1;257;1
WireConnection;206;0;197;0
WireConnection;227;0;217;0
WireConnection;227;1;225;0
WireConnection;276;0;275;0
WireConnection;276;1;275;0
WireConnection;310;0;275;0
WireConnection;205;0;195;0
WireConnection;247;0;236;0
WireConnection;247;1;244;0
WireConnection;249;0;239;0
WireConnection;249;1;235;0
WireConnection;213;0;212;0
WireConnection;213;1;215;0
WireConnection;277;0;276;0
WireConnection;246;0;237;0
WireConnection;246;1;242;0
WireConnection;230;0;224;0
WireConnection;230;1;223;0
WireConnection;268;0;264;0
WireConnection;268;1;258;1
WireConnection;267;0;259;0
WireConnection;267;1;253;1
WireConnection;275;0;271;0
WireConnection;275;1;272;0
WireConnection;275;2;273;0
WireConnection;275;3;274;0
WireConnection;228;0;222;0
WireConnection;228;1;216;0
WireConnection;235;0;232;0
WireConnection;235;1;228;0
WireConnection;244;0;234;0
WireConnection;244;1;229;0
WireConnection;208;0;201;0
WireConnection;257;0;248;0
WireConnection;233;0;220;0
WireConnection;233;1;221;0
WireConnection;253;0;249;0
WireConnection;258;0;246;0
WireConnection;274;0;269;0
WireConnection;229;0;218;0
WireConnection;229;1;219;0
WireConnection;256;0;247;0
WireConnection;272;0;270;0
WireConnection;242;0;231;0
WireConnection;242;1;233;0
WireConnection;273;0;267;0
WireConnection;0;0;304;0
ASEEND*/
//CHKSM=F79061224F8C960D4E738EC4B4C35A67CDB87A8B