// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Skybox/Stylized Skybox"
{
	Properties
	{
		_SkyboxScaleY("Skybox Scale Y", Float) = 2
		_SkyboxScaleX("Skybox Scale X", Float) = 8
		_DaySkyColor("DaySkyColor", Color) = (0,0.8627452,0.8117648,1)
		_DayHorizonColor("DayHorizonColor", Color) = (0.2941177,0.572549,0.9529412,1)
		_NightSkyColor("NightSkyColor", Color) = (0.09411766,0.0627451,0.1921569,1)
		_NightHorizonColor("NightHorizonColor", Color) = (0.1254902,0.1921569,0.4509804,1)
		_StarScale("Star Scale", Float) = 6.8
		_StarAngleOffset("Star Angle Offset", Float) = 20
		_StarSize("Star Size", Float) = 50
		_StarThreshold("Star Threshold", Range( 0 , 1)) = 0.54
		_SunRadius("Sun Radius", Range( 0 , 1)) = 1
		_SunExp("Sun Exp", Float) = 3
		_MoonRadius("Moon Radius", Range( 0 , 1)) = 0.4
		_CrescnetMoonRadius("CrescnetMoon Radius", Range( 0 , 1)) = 0.3
		_MoonExp("Moon Exp", Float) = 30
		_MoonPhase("MoonPhase", Float) = 1
		_MoonColor("Moon Color", Color) = (0.9811321,0.9198574,0.4874806,0)
		_T_CloudNoise("T_CloudNoise", 2D) = "white" {}
		_CloudSpeed("Cloud Speed", Float) = 1
		_CloudHeight("Cloud Height", Range( 0 , 1)) = 0.48
		_CloudEdge("Cloud Edge", Range( 0 , 1)) = 0.49
		_HorizonFog("HorizonFog", Float) = 25
		_FogHeight("Fog Height", Range( -1 , 1)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Background" "Queue"="Background" }
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
			Tags { "LightMode"="ForwardBase"  }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardBRDF.cginc"
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform float _StarThreshold;
			uniform float _SkyboxScaleX;
			uniform float _SkyboxScaleY;
			uniform float _StarAngleOffset;
			uniform float _StarScale;
			uniform float _StarSize;
			uniform float4 _DayHorizonColor;
			uniform float4 _DaySkyColor;
			uniform float4 _NightHorizonColor;
			uniform float4 _NightSkyColor;
			uniform float _SunRadius;
			uniform float _SunExp;
			uniform float4 _MoonColor;
			uniform float _MoonRadius;
			uniform float _MoonExp;
			uniform float _MoonPhase;
			uniform float _CrescnetMoonRadius;
			uniform sampler2D _T_CloudNoise;
			uniform float _CloudSpeed;
			uniform float _CloudHeight;
			uniform float _CloudEdge;
			uniform float _FogHeight;
			uniform float _HorizonFog;
			struct Gradient
			{
				int type;
				int colorsLength;
				int alphasLength;
				float4 colors[8];
				float2 alphas[8];
			};
			
			Gradient NewGradient(int type, int colorsLength, int alphasLength, 
			float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
			float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
			{
				Gradient g;
				g.type = type;
				g.colorsLength = colorsLength;
				g.alphasLength = alphasLength;
				g.colors[ 0 ] = colors0;
				g.colors[ 1 ] = colors1;
				g.colors[ 2 ] = colors2;
				g.colors[ 3 ] = colors3;
				g.colors[ 4 ] = colors4;
				g.colors[ 5 ] = colors5;
				g.colors[ 6 ] = colors6;
				g.colors[ 7 ] = colors7;
				g.alphas[ 0 ] = alphas0;
				g.alphas[ 1 ] = alphas1;
				g.alphas[ 2 ] = alphas2;
				g.alphas[ 3 ] = alphas3;
				g.alphas[ 4 ] = alphas4;
				g.alphas[ 5 ] = alphas5;
				g.alphas[ 6 ] = alphas6;
				g.alphas[ 7 ] = alphas7;
				return g;
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			
			inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
			{
				float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
				UV = frac( sin(mul(UV, m) ) * 46839.32 );
				return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
			}
			
			//x - Out y - Cells
			float3 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity, inout float2 mr )
			{
				float2 g = floor( UV * CellDensity );
				float2 f = frac( UV * CellDensity );
				float t = 8.0;
				float3 res = float3( 8.0, 0.0, 0.0 );
			
				for( int y = -1; y <= 1; y++ )
				{
					for( int x = -1; x <= 1; x++ )
					{
						float2 lattice = float2( x, y );
						float2 offset = UnityVoronoiRandomVector( lattice + g, AngleOffset );
						float d = distance( lattice + offset, f );
			
						if( d < res.x )
						{
							mr = f - lattice - offset;
							res = float3( d, offset.x, offset.y );
						}
					}
				}
				return res;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xyz = v.ase_texcoord.xyz;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
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
				float3 worldSpaceLightDir = Unity_SafeNormalize(UnityWorldSpaceLightDir(WorldPosition));
				float dotResult196 = dot( worldSpaceLightDir , float3(0,-1,0) );
				float LightDirectionDot197 = dotResult196;
				float smoothstepResult179 = smoothstep( _StarThreshold , 1.0 , LightDirectionDot197);
				Gradient gradient57 = NewGradient( 0, 2, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 0.5647059 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 appendResult50 = (float2(_SkyboxScaleX , _SkyboxScaleY));
				float3 normalizeResult8 = normalize( WorldPosition );
				float3 break9 = normalizeResult8;
				float2 appendResult21 = (float2(( atan2( break9.x , break9.z ) / 6.28318548202515 ) , ( asin( break9.y ) / ( 0.5 * UNITY_PI ) )));
				float2 SphereSkyboxUV30 = appendResult21;
				float2 temp_output_53_0 = ( appendResult50 * SphereSkyboxUV30 );
				float2 uv41 = 0;
				float3 unityVoronoy41 = UnityVoronoi(temp_output_53_0,_StarAngleOffset,_StarScale,uv41);
				float4 lerpResult39 = lerp( _DayHorizonColor , _DaySkyColor , (SphereSkyboxUV30).y);
				float4 lerpResult192 = lerp( _NightHorizonColor , _NightSkyColor , (SphereSkyboxUV30).y);
				float4 lerpResult193 = lerp( lerpResult39 , lerpResult192 , ( ( LightDirectionDot197 + 1.0 ) / 2.0 ));
				float3 texCoord76 = i.ase_texcoord1.xyz;
				texCoord76.xy = i.ase_texcoord1.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult88 = smoothstep( 0.0 , 1.0 , pow( ( distance( _WorldSpaceLightPos0.xyz , texCoord76 ) / _SunRadius ) , _SunExp ));
				float3 temp_output_103_0 = ( -1.0 * _WorldSpaceLightPos0.xyz );
				float3 texCoord94 = i.ase_texcoord1.xyz;
				texCoord94.xy = i.ase_texcoord1.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult100 = smoothstep( 0.0 , 1.0 , saturate( pow( ( distance( temp_output_103_0 , texCoord94 ) / _MoonRadius ) , _MoonExp ) ));
				float3 texCoord153 = i.ase_texcoord1.xyz;
				texCoord153.xy = i.ase_texcoord1.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float3 appendResult124 = (float3(( texCoord153.x + _MoonPhase ) , texCoord153.y , texCoord153.z));
				float smoothstepResult160 = smoothstep( 0.0 , 1.0 , saturate( pow( ( distance( temp_output_103_0 , appendResult124 ) / _CrescnetMoonRadius ) , _MoonExp ) ));
				float4 Sky271 = ( ( ( smoothstepResult179 * ( SampleGradient( gradient57, (temp_output_53_0).y ) * pow( ( 1.0 - saturate( unityVoronoy41.x ) ) , _StarSize ) ) ) + lerpResult193 ) + ( ( 1.0 - saturate( smoothstepResult88 ) ) + ( _MoonColor * saturate( ( ( 1.0 - smoothstepResult100 ) - ( 1.0 - smoothstepResult160 ) ) ) ) ) );
				float temp_output_228_0 = ( _Time.y * ( _CloudSpeed * 0.01 ) );
				float2 appendResult237 = (float2(temp_output_228_0 , temp_output_228_0));
				float temp_output_225_0 = ( saturate( tex2D( _T_CloudNoise, (SphereSkyboxUV30*float2( 6,2 ) + ( temp_output_228_0 * -2.0 )) ).r ) * saturate( tex2D( _T_CloudNoise, (SphereSkyboxUV30*float2( 8,4 ) + appendResult237) ).r ) );
				float4 temp_cast_0 = (saturate( temp_output_225_0 )).xxxx;
				float div239=256.0/float(6);
				float4 posterize239 = ( floor( temp_cast_0 * div239 ) / div239 );
				float4 Cloud268 = (float4( 0.5,0.5,0.5,0 ) + (posterize239 - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0.5,0.5,0.5,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
				float2 _Vector3 = float2(1,2);
				float smoothstepResult244 = smoothstep( _CloudHeight , saturate( ( _CloudHeight + _CloudEdge ) ) , ( (SphereSkyboxUV30).y + 0.2 ));
				float CloudMask266 = step( 0.99 , ( (_Vector3.x + (temp_output_225_0 - 0.0) * (_Vector3.y - _Vector3.x) / (1.0 - 0.0)) * ( 1.0 - smoothstepResult244 ) ) );
				float4 lerpResult256 = lerp( Sky271 , Cloud268 , CloudMask266);
				float FogMask284 = pow( saturate( ( ( 1.0 - (SphereSkyboxUV30).y ) - _FogHeight ) ) , _HorizonFog );
				float4 lerpResult285 = lerp( lerpResult256 , unity_FogColor , FogMask284);
				
				
				finalColor = lerpResult285;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
-1920;-598.3333;1920;1029;4736.651;1076.212;3.623044;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;-1387.619,154.4316;Inherit;False;1587.284;450.0487;Comment;11;7;8;9;17;20;16;11;15;19;21;30;Sphere Skybox UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-1337.619,271.6289;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;8;-1131.619,272.6289;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;273;2289.469,2460.824;Inherit;False;2534.272;1137.225;Comment;6;171;170;163;166;169;167;Moon;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;9;-943.8771,272.3005;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;171;2339.469,3205.006;Inherit;False;1900.829;393.043;Comment;11;164;153;162;124;168;154;157;158;159;160;161;CrescentMoon;1,1,1,1;0;0
Node;AmplifyShaderEditor.PiNode;16;-859.2803,494.4802;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;20;-635.153,288.9126;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;17;-783.4832,211.5845;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;11;-797.4222,419.5133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;2418.632,3441.676;Inherit;False;Property;_MoonPhase;MoonPhase;16;0;Create;True;0;0;0;False;0;False;1;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;170;2534.263,2510.824;Inherit;False;1683.636;507.4816;Comment;12;93;104;103;94;96;95;97;98;99;101;100;102;FullMoon;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;153;2389.469,3255.006;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;162;2675.227,3280.87;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-641.8329,442.7538;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;93;2559.964,2652.028;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-510.4624,212.8701;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;2584.263,2560.824;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;2859.842,2565.277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;2594.198,2839.305;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;124;2869.765,3354.379;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;270;1658.366,3696.918;Inherit;False;3701.348;1156.449;Comment;35;229;230;227;228;234;216;237;235;233;245;218;217;246;241;242;247;221;222;248;243;223;224;244;253;225;249;238;250;239;252;255;240;254;266;268;Cloud;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-281.6436,211.6521;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;187;885.8635,-478.6956;Inherit;False;2908.022;854.1492;Comment;20;176;52;51;50;31;44;53;43;41;45;58;57;56;46;54;59;60;179;178;198;Star;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;154;3066.028,3356.073;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;3055.718,2693.005;Inherit;False;Property;_MoonRadius;Moon Radius;13;0;Create;True;0;0;0;False;0;False;0.4;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;96;3081.545,2565.105;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;3007.524,3483.049;Inherit;False;Property;_CrescnetMoonRadius;CrescnetMoon Radius;14;0;Create;True;0;0;0;False;0;False;0.3;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;936.8899,54.29744;Inherit;False;Property;_SkyboxScaleY;Skybox Scale Y;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;935.8635,-28.57706;Inherit;False;Property;_SkyboxScaleX;Skybox Scale X;2;0;Create;True;0;0;0;False;0;False;8;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;1708.366,4043.937;Inherit;False;Property;_CloudSpeed;Cloud Speed;20;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-28.33494,204.4316;Inherit;False;SphereSkyboxUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;97;3267.993,2837.605;Inherit;False;Property;_MoonExp;Moon Exp;15;0;Create;True;0;0;0;False;0;False;30;33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;157;3252.818,3355.082;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;2875.794,1853.034;Inherit;False;1414.227;481.3732;Comment;10;63;76;71;64;72;88;89;87;73;75;Sun;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;227;1838.036,3954.839;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;98;3268.335,2564.114;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;1133.565,2.805071;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;958.7972,145.4536;Inherit;True;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;1904.646,4049.886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;63;2964.794,1964.66;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;194;-1347.506,1454.046;Inherit;False;Constant;_Vector1;Vector 1;16;0;Create;True;0;0;0;False;0;False;0,-1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;2069.82,3955.249;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;158;3424.726,3355.919;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;99;3440.243,2564.95;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1635.414,153.8964;Inherit;False;Property;_StarAngleOffset;Star Angle Offset;8;0;Create;True;0;0;0;False;0;False;20;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;1702.261,231.912;Inherit;False;Property;_StarScale;Star Scale;7;0;Create;True;0;0;0;False;0;False;6.8;18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;2969.059,2089.407;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1299.644,73.61014;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;195;-1358.288,1276.878;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;237;2440.932,4168.209;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;41;1865.342,75.56013;Inherit;True;0;0;1;0;1;False;1;True;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SaturateNode;101;3631.696,2564.665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;196;-1095.993,1367.159;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;2581.323,3962.113;Inherit;False;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;159;3650.056,3354.33;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;64;3215.087,2029.771;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;2291.519,3818.025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;233;2651.274,3791.094;Inherit;False;Constant;_Vector0;Vector 0;21;0;Create;True;0;0;0;False;0;False;6,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;234;2660.838,4140.125;Inherit;False;Constant;_Vector2;Vector 2;21;0;Create;True;0;0;0;False;0;False;8,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;71;3318.261,2166.863;Inherit;False;Property;_SunRadius;Sun Radius;11;0;Create;True;0;0;0;False;0;False;1;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;274;2001.31,458.6742;Inherit;False;1563.348;1315.26;Comment;6;61;202;199;200;201;193;SkyColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-879.2127,1364.683;Inherit;False;LightDirectionDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;217;2908.9,3772.157;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;218;2893.439,4123.824;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;72;3401.877,2030.101;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;3353.775,4496.705;Inherit;False;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;246;3421.407,4736.756;Inherit;False;Property;_CloudEdge;Cloud Edge;22;0;Create;True;0;0;0;False;0;False;0.49;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;3574.316,2022.034;Inherit;False;Property;_SunExp;Sun Exp;12;0;Create;True;0;0;0;False;0;False;3;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;2055.624,508.6742;Inherit;False;782.6588;569.203;Comment;5;37;34;36;38;39;DayColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;245;3435.237,4635.237;Inherit;False;Property;_CloudHeight;Cloud Height;21;0;Create;True;0;0;0;False;0;False;0.48;0.18;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;45;2079.046,75.91138;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;202;2051.31,1204.731;Inherit;False;782.6587;569.2028;Comment;5;188;189;190;191;192;NightColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;100;3840.923,2564.114;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;3831.921,3351.174;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;2101.31,1658.934;Inherit;False;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;222;3322.921,4088.902;Inherit;True;Property;_TextureSample1;Texture Sample 1;19;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;221;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;297;2914.122,5149.41;Inherit;False;1411.986;311.395;Comment;8;275;276;277;280;278;279;298;299;Fog Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;87;3570.316,1903.034;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;221;3324.19,3746.918;Inherit;True;Property;_T_CloudNoise;T_CloudNoise;19;0;Create;True;0;0;0;False;0;False;-1;None;126ef3d65fae3b6459fbc2867615e642;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;58;1708.23,-212.1148;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;242;3618.792,4499.304;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;161;4060.296,3356.375;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;3002.022,1105.56;Inherit;False;197;LightDirectionDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;2105.624,962.8755;Inherit;False;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;46;2277.943,75.40979;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;4037.898,2564.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;57;1687.991,-285.4873;Inherit;False;0;2;2;0,0,0,0;1,1,1,0.5647059;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;247;3724.264,4720.367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;2440.54,185.9257;Inherit;False;Property;_StarSize;Star Size;9;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;248;3910.165,4720.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;2293.465,756.6731;Inherit;False;Property;_DaySkyColor;DaySkyColor;3;0;Create;True;0;0;0;False;0;False;0,0.8627452,0.8117648,1;0,0.8627452,0.8117648,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;275;2964.122,5199.41;Inherit;False;30;SphereSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;223;3748.209,3948.832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;38;2302.624,962.8755;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;3086.366,-297.0894;Inherit;False;197;LightDirectionDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;189;2287.835,1452.731;Inherit;False;Property;_NightSkyColor;NightSkyColor;5;0;Create;True;0;0;0;False;0;False;0.09411766,0.0627451,0.1921569,1;0.6705883,0.3764706,0.4784313,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;88;3743.316,1903.034;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;243;3884.792,4504.304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;224;3748.209,4053.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;200;3266.834,1110.918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;163;4310.243,3019.396;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;191;2281.421,1254.731;Inherit;False;Property;_NightHorizonColor;NightHorizonColor;6;0;Create;True;0;0;0;False;0;False;0.1254902,0.1921569,0.4509804,1;0.07058816,0.4352941,0.6392157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;59;2009.261,-290.5147;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;190;2298.31,1658.934;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;2285.736,558.6743;Inherit;False;Property;_DayHorizonColor;DayHorizonColor;4;0;Create;True;0;0;0;False;0;False;0.2941177,0.572549,0.9529412,1;0.2941176,0.572549,0.9529411,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;3056.521,-204.9353;Inherit;False;Property;_StarThreshold;Star Threshold;10;0;Create;True;0;0;0;False;0;False;0.54;0.54;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;2571.991,76.18724;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;201;3412.657,1110.153;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;244;4166.763,4621.223;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;3984.343,3985.85;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;166;4356.604,2773.821;Inherit;False;Property;_MoonColor;Moon Color;17;0;Create;True;0;0;0;False;0;False;0.9811321,0.9198574,0.4874806,0;0.9857615,1,0.3930816,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;2818.2,-90.92554;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;39;2572.615,664.2411;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;192;2568.302,1360.299;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;73;3930.662,1903.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;253;4204.512,4297.76;Inherit;False;Constant;_Vector3;Vector 3;23;0;Create;True;0;0;0;False;0;False;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;169;4468.312,3019.406;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;276;3239.027,5200.114;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;179;3380.372,-219.8142;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;238;4267.159,3986.423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;4660.407,2896.012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;299;3554.796,5344.493;Inherit;False;Property;_FogHeight;Fog Height;24;0;Create;True;0;0;0;False;0;False;0;0.22;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;4388.042,4471.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;277;3460.988,5204.777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;250;4380.582,4257.304;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;3630.552,-108.432;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;193;3319.284,858.2682;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;75;4110.021,1903.975;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;4148.209,326.3508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;239;4471.159,3988.423;Inherit;False;6;2;1;COLOR;0,0,0,0;False;0;INT;6;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;298;3682.934,5204.445;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;4782.701,4372.593;Inherit;False;Constant;_Float1;Float 1;23;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;4630.489,4451.061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;5069.628,1904.185;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;240;4690.159,3988.423;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0.5,0.5,0.5,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;172;5337.036,1169.32;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;254;4955.384,4427.412;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;280;4019.901,5319.756;Inherit;False;Property;_HorizonFog;HorizonFog;23;0;Create;True;0;0;0;False;0;False;25;33.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;278;3877.05,5204.243;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;271;5559.158,1167.375;Inherit;False;Sky;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;5131.715,4421.899;Inherit;False;CloudMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;268;4915.715,3981.899;Inherit;False;Cloud;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;279;4112.097,5203.704;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;4416.288,5201.516;Inherit;True;FogMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;6459.34,2308.2;Inherit;False;271;Sky;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;267;6457.972,2485.715;Inherit;False;266;CloudMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;269;6456.357,2397.357;Inherit;False;268;Cloud;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;256;6733.024,2380.019;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;214;-1372.785,704.0428;Inherit;False;1137.982;436.0948;Comment;7;213;212;209;208;207;210;206;Flat Skybox UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;291;6748.791,2528.834;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;286;6886.654,2622.44;Inherit;False;284;FogMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;6128.516,2046.563;Inherit;False;210;FlatSkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SignOpNode;215;-630.0234,1039.94;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-462.8039,817.2109;Inherit;False;FlatSkyboxUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;6385.267,2037.387;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;209;-830.6402,890.3791;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;206;-1307.026,789.3498;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;208;-834.8574,754.0428;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;285;7008.23,2380.154;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;207;-680.1317,822.0802;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-1322.785,1025.138;Inherit;False;Property;_SkyHeightOffset;Sky Height Offset;18;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;212;-1022.785,947.1378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;7226.475,2380.186;Float;False;True;-1;2;ASEMaterialInspector;100;1;Skybox/Stylized Skybox;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Background=RenderType;Queue=Background=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;LightMode=ForwardBase;=;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;8;0;7;0
WireConnection;9;0;8;0
WireConnection;17;0;9;0
WireConnection;17;1;9;2
WireConnection;11;0;9;1
WireConnection;162;0;153;1
WireConnection;162;1;164;0
WireConnection;15;0;11;0
WireConnection;15;1;16;0
WireConnection;19;0;17;0
WireConnection;19;1;20;0
WireConnection;103;0;104;0
WireConnection;103;1;93;1
WireConnection;124;0;162;0
WireConnection;124;1;153;2
WireConnection;124;2;153;3
WireConnection;21;0;19;0
WireConnection;21;1;15;0
WireConnection;154;0;103;0
WireConnection;154;1;124;0
WireConnection;96;0;103;0
WireConnection;96;1;94;0
WireConnection;30;0;21;0
WireConnection;157;0;154;0
WireConnection;157;1;168;0
WireConnection;98;0;96;0
WireConnection;98;1;95;0
WireConnection;50;0;51;0
WireConnection;50;1;52;0
WireConnection;230;0;229;0
WireConnection;228;0;227;0
WireConnection;228;1;230;0
WireConnection;158;0;157;0
WireConnection;158;1;97;0
WireConnection;99;0;98;0
WireConnection;99;1;97;0
WireConnection;53;0;50;0
WireConnection;53;1;31;0
WireConnection;237;0;228;0
WireConnection;237;1;228;0
WireConnection;41;0;53;0
WireConnection;41;1;44;0
WireConnection;41;2;43;0
WireConnection;101;0;99;0
WireConnection;196;0;195;0
WireConnection;196;1;194;0
WireConnection;159;0;158;0
WireConnection;64;0;63;1
WireConnection;64;1;76;0
WireConnection;235;0;228;0
WireConnection;197;0;196;0
WireConnection;217;0;216;0
WireConnection;217;1;233;0
WireConnection;217;2;235;0
WireConnection;218;0;216;0
WireConnection;218;1;234;0
WireConnection;218;2;237;0
WireConnection;72;0;64;0
WireConnection;72;1;71;0
WireConnection;45;0;41;0
WireConnection;100;0;101;0
WireConnection;160;0;159;0
WireConnection;222;1;218;0
WireConnection;87;0;72;0
WireConnection;87;1;89;0
WireConnection;221;1;217;0
WireConnection;58;0;53;0
WireConnection;242;0;241;0
WireConnection;161;0;160;0
WireConnection;46;0;45;0
WireConnection;102;0;100;0
WireConnection;247;0;245;0
WireConnection;247;1;246;0
WireConnection;248;0;247;0
WireConnection;223;0;221;1
WireConnection;38;0;37;0
WireConnection;88;0;87;0
WireConnection;243;0;242;0
WireConnection;224;0;222;1
WireConnection;200;0;199;0
WireConnection;163;0;102;0
WireConnection;163;1;161;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;190;0;188;0
WireConnection;54;0;46;0
WireConnection;54;1;56;0
WireConnection;201;0;200;0
WireConnection;244;0;243;0
WireConnection;244;1;245;0
WireConnection;244;2;248;0
WireConnection;225;0;223;0
WireConnection;225;1;224;0
WireConnection;60;0;59;0
WireConnection;60;1;54;0
WireConnection;39;0;34;0
WireConnection;39;1;36;0
WireConnection;39;2;38;0
WireConnection;192;0;191;0
WireConnection;192;1;189;0
WireConnection;192;2;190;0
WireConnection;73;0;88;0
WireConnection;169;0;163;0
WireConnection;276;0;275;0
WireConnection;179;0;198;0
WireConnection;179;1;176;0
WireConnection;238;0;225;0
WireConnection;167;0;166;0
WireConnection;167;1;169;0
WireConnection;249;0;244;0
WireConnection;277;0;276;0
WireConnection;250;0;225;0
WireConnection;250;3;253;1
WireConnection;250;4;253;2
WireConnection;178;0;179;0
WireConnection;178;1;60;0
WireConnection;193;0;39;0
WireConnection;193;1;192;0
WireConnection;193;2;201;0
WireConnection;75;0;73;0
WireConnection;55;0;178;0
WireConnection;55;1;193;0
WireConnection;239;1;238;0
WireConnection;298;0;277;0
WireConnection;298;1;299;0
WireConnection;252;0;250;0
WireConnection;252;1;249;0
WireConnection;105;0;75;0
WireConnection;105;1;167;0
WireConnection;240;0;239;0
WireConnection;172;0;55;0
WireConnection;172;1;105;0
WireConnection;254;0;255;0
WireConnection;254;1;252;0
WireConnection;278;0;298;0
WireConnection;271;0;172;0
WireConnection;266;0;254;0
WireConnection;268;0;240;0
WireConnection;279;0;278;0
WireConnection;279;1;280;0
WireConnection;284;0;279;0
WireConnection;256;0;272;0
WireConnection;256;1;269;0
WireConnection;256;2;267;0
WireConnection;210;0;207;0
WireConnection;3;1;211;0
WireConnection;209;0;206;3
WireConnection;209;1;212;0
WireConnection;208;0;206;1
WireConnection;208;1;212;0
WireConnection;285;0;256;0
WireConnection;285;1;291;0
WireConnection;285;2;286;0
WireConnection;207;0;208;0
WireConnection;207;1;209;0
WireConnection;212;0;206;2
WireConnection;212;1;213;0
WireConnection;2;0;285;0
ASEEND*/
//CHKSM=D41DB035D5212D4922248DA6AD957946CA29F6AA