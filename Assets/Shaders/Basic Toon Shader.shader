// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon/BasicToonShader"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0.9339623,0.6019919,0.5080989,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 1
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		[HDR]_RimColor("Rim Color", Color) = (0,1,0.8758622,0)
		_RimPower("Rim Power", Range( 0 , 5)) = 0.5
		_RimOffset("Rim Offset", Float) = 1
		_Diffuse("Diffuse", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		[Toggle(_USENORMALMAP_ON)] _UseNormalMap("Use Normal Map?", Float) = 0
		_Gloss("Gloss", Float) = 0.5
		_SpecularIntensity("Specular Intensity", Float) = 0
		_SpecularMap("Specular Map", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USENORMALMAP_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Gloss;
		uniform sampler2D _SpecularMap;
		uniform float4 _SpecularMap_ST;
		uniform float4 _SpecularColor;
		uniform float _SpecularIntensity;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			#ifdef _USENORMALMAP_ON
				float3 staticSwitch60 = saturate( normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) ) );
			#else
				float3 staticSwitch60 = ase_worldNormal;
			#endif
			float3 Normal54 = staticSwitch60;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult3 = dot( Normal54 , ase_worldlightDir );
			float NdotL77 = dotResult3;
			float2 temp_cast_0 = (saturate( (NdotL77*0.5 + 0.5) )).xx;
			float4 tex2DNode6 = tex2D( _ToonRamp, temp_cast_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi11 = gi;
			float3 diffNorm11 = WorldNormalVector( i , Normal54 );
			gi11 = UnityGI_Base( data, 1, diffNorm11 );
			float3 indirectDiffuse11 = gi11.indirect.diffuse + diffNorm11 * 0.0001;
			float4 temp_output_23_0 = ( ( tex2D( _Diffuse, uv_Diffuse ) * tex2DNode6 ) * ( ase_lightColor * float4( ( indirectDiffuse11 + ase_lightAtten ) , 0.0 ) ) );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult65 = normalize( ( ase_worldlightDir + ase_worldViewDir ) );
			float3 HalfVector70 = normalizeResult65;
			float dotResult84 = dot( HalfVector70 , Normal54 );
			float smoothstepResult87 = smoothstep( 0.6 , 0.8 , pow( dotResult84 , _Gloss ));
			float2 uv_SpecularMap = i.uv_texcoord * _SpecularMap_ST.xy + _SpecularMap_ST.zw;
			float4 lerpResult102 = lerp( _SpecularColor , ase_lightColor , 0.4);
			float4 Albedo116 = tex2DNode6;
			float4 Spcular94 = ( ase_lightAtten * ( ( ( smoothstepResult87 * ( tex2D( _SpecularMap, uv_SpecularMap ).g * lerpResult102 ) ) * Albedo116 ) * _SpecularIntensity ) );
			float fresnelNdotV75 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode75 = ( _RimOffset + 1.0 * pow( 1.0 - fresnelNdotV75, _RimPower ) );
			float4 Rim81 = ( saturate( ( fresnelNode75 * ( NdotL77 * ase_lightAtten ) ) ) * ( _RimColor * ase_lightColor ) );
			c.rgb = ( temp_output_23_0 + Spcular94 + Rim81 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
0;30.66667;1706.667;1015;2484.618;-207.4701;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;62;-3263.962,-6.106903;Inherit;False;1125.438;459.0918;Normal;6;53;61;60;54;187;188;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;53;-3246.76,212.398;Inherit;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;0;False;0;False;-1;None;eaea6f8d31422bb4fa4198dba5d81cb9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;187;-2916.036,217.4299;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;61;-3001.352,48.20903;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;188;-2681.829,218.3428;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;71;-1343.677,1470.073;Inherit;False;845;396;HalfVector;5;65;67;68;66;70;HalfVector;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;60;-2717.962,43.8931;Inherit;False;Property;_UseNormalMap;Use Normal Map?;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-2436.124,44.8853;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;67;-1249.674,1682.073;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;48;-2013,31.00003;Inherit;False;540.401;320.6003;Comment;4;3;2;55;77;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;66;-1293.675,1520.073;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1038.672,1615.073;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-2001.799,204.1998;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1973.244,75.51054;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1777.798,144.5998;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1143.099,-115.6995;Inherit;False;723.599;290;Also know as Lambert Wrap or Half Lambert;3;5;4;15;Diffuse Wrap;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;65;-895.1021,1615.147;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-726.672,1611.073;Inherit;False;HalfVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1382.082,2103.659;Inherit;False;2179.594;1054.272;Specular;22;83;82;100;84;103;86;96;102;89;88;85;104;87;91;97;92;90;93;94;101;189;190;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1660.97,147.0111;Inherit;False;NdotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1074.099,75.30051;Float;False;Constant;_HalfLambert;Half-Lambert;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;4;-826.6974,-56.69949;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1332.082,2192.325;Inherit;False;70;HalfVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1331.327,2318.715;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;15;-593.4999,-56.89988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;84;-1129.189,2238.856;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-735.903,2975.931;Inherit;False;Constant;_SpecularTransition;Specular Transition;10;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;101;-806.903,2633.931;Inherit;False;Property;_SpecularColor;Specular Color;12;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;117;-331.2315,-359.3239;Inherit;False;781.1381;505.0234;Comment;4;116;42;6;43;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1060.288,2367.556;Inherit;False;Property;_Gloss;Gloss;8;0;Create;True;0;0;0;False;0;False;0.5;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;100;-769.9031,2825.931;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;89;-750.8887,2384.457;Inherit;False;Constant;_SpecularMax;Specular Max;10;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-749.5883,2302.557;Inherit;False;Constant;_SpecularMIn;Specular MIn;9;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;102;-547.9035,2726.931;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-284.2316,-84.30046;Inherit;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;0;False;0;False;-1;8008c1b7ec5390146b51f74f817bb5b4;d199b5ee3f3282344b91834dc4e3703a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;96;-596.1274,2492.203;Inherit;True;Property;_SpecularMap;Specular Map;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;50;-1344,768;Inherit;False;1617.938;553.8222;;13;33;46;32;34;47;28;24;75;76;78;79;80;81;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;85;-906.8885,2238.856;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;87;-553.2903,2237.556;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1251.2,875.2002;Float;False;Property;_RimOffset;Rim Offset;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1311.999,992.0029;Float;False;Property;_RimPower;Rim Power;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;76;-998.5712,1214.212;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-250.9032,2624.931;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-985.7642,1099.012;Inherit;False;77;NdotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;75.26899,29.23004;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;75;-1022.573,843.0142;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-263.3166,2235.464;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-69.93749,2360.925;Inherit;False;116;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;52;-874.676,256.1136;Inherit;False;812;304;Comment;6;7;8;11;10;12;64;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-784.1642,1143.812;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-27.93748,2235.925;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-436.8002,1035.2;Float;False;Property;_RimColor;Rim Color;1;1;[HDR];Create;True;0;0;0;False;0;False;0,1,0.8758622,0;2,2,2,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-603.2643,918.411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;96.11098,2372.358;Inherit;False;Property;_SpecularIntensity;Specular Intensity;9;0;Create;True;0;0;0;False;0;False;0;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;47;-384.0004,1211.2;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;64;-836.0431,415.1302;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-185.6,1017.6;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;32;-296.0003,927.9998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;7;-741.7271,490.4446;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;11;-650.6127,420.1136;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;137.9111,2235.556;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;92;115.8113,2153.659;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-417.2741,420.1064;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;8;-720.676,302.1136;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;43;-281.2316,-309.3239;Inherit;True;Property;_Diffuse;Diffuse;5;0;Create;True;0;0;0;False;0;False;-1;None;70ec6033d0d6c5c4082045acdc91a621;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-33.59995,926.3995;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;366.7115,2214.757;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;106.4793,-181.8353;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-294.5412,302.7826;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;569.5112,2320.057;Inherit;False;Spcular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;57.43542,1087.811;Inherit;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;887.8929,781.0553;Inherit;False;81;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2013,545;Inherit;False;507.201;385.7996;Comment;3;37;38;56;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;887.5161,682.5286;Inherit;False;94;Spcular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;727.4316,281.0251;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;230;-1370.444,3421.138;Inherit;False;5174.186;1253.498;Comment;45;192;191;194;193;196;195;198;197;201;202;203;200;199;206;205;204;207;227;222;208;209;210;221;211;213;212;223;225;214;226;215;216;229;228;217;106;219;181;218;185;153;186;145;180;122;Sketch;1,1,1,1;0;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;193;-1112.444,3791.139;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;197;-648.4441,3599.139;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;191;-1304.444,3791.139;Inherit;False;Constant;_Zero;Zero;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;222;893.7811,4559.637;Inherit;False;Property;_SketchSpeed;Sketch Speed;15;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;180;3361.659,3868.731;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;37;-1917,753;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;1036.413,519.4565;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;149;-298.5397,581.3564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;213;478.7785,3963.503;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;3164.543,3869.404;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;194;-1096.444,3471.139;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;227;877.7811,4367.635;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-200.4442,3471.139;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;205;-312.4439,4175.138;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;2767.907,3870.98;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;216;1307.089,3966.244;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;3575.741,3863.751;Inherit;False;SketchMax;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;208;-24.44473,4175.138;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;3084.435,4030.015;Inherit;False;147;shadowArea;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;1679.093,3950.861;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenParams;207;306.9326,4227.763;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;215;846.7789,3963.503;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;654.7786,3867.504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;577.8118,575.7297;Inherit;False;122;SketchMax;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1954.282,631.3028;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;200;-456.4441,3791.139;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-408.4439,3631.138;Inherit;False;Property;_TexScale;Tex Scale;2;0;Create;True;0;0;0;False;0;False;0.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;202;-600.4441,4063.137;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;181;2651.418,3986.143;Inherit;False;Property;_SketchBrightness;Sketch Brightness;13;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;212;754.9325,4227.763;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-200.4442,3775.138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;196;-856.4438,3791.139;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;192;-1320.444,3471.139;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;183.5555,4079.137;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;1260.541,454.47;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;218;2362.341,3866.236;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;219;2346.214,4072.665;Inherit;False;Property;_SketchBlend;Sketch Blend;14;0;Create;True;0;0;0;False;0;False;0.7;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;209;-24.44473,3615.139;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-120.498,576.3309;Inherit;False;shadowArea;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;223;1309.781,4463.637;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;186;2980.539,3870.432;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;106;1908.537,3746.909;Inherit;True;Property;_SketchTex;Sketch Tex;11;0;Create;True;0;0;0;False;0;False;-1;a0d03d906b6264d4c8c02b0ffd7bc8c2;a0d03d906b6264d4c8c02b0ffd7bc8c2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;38;-1661,673;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;217;1909.161,4014.606;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;a0d03d906b6264d4c8c02b0ffd7bc8c2;a0d03d906b6264d4c8c02b0ffd7bc8c2;True;0;False;white;Auto;False;Instance;106;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;199;-456.4441,3471.139;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;229;1565.617,4086.299;Inherit;False;Property;_SketchScaleDiff;Sketch Scale Diff;16;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;198;-648.4441,3919.138;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;211;546.933,4227.763;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;177;803.7595,583.0834;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;152;-482.37,581.6583;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;225;1563.013,4461.006;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;1101.781,4463.637;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;226;1729.34,4462.305;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;195;-840.4438,3471.139;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;203;-568.444,4319.138;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1409.346,331.4565;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toon/BasicToonShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;True;1;0.9339623,0.6019919,0.5080989,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;187;0;53;0
WireConnection;188;0;187;0
WireConnection;60;1;61;0
WireConnection;60;0;188;0
WireConnection;54;0;60;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;3;0;55;0
WireConnection;3;1;2;0
WireConnection;65;0;68;0
WireConnection;70;0;65;0
WireConnection;77;0;3;0
WireConnection;4;0;77;0
WireConnection;4;1;5;0
WireConnection;4;2;5;0
WireConnection;15;0;4;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;102;2;103;0
WireConnection;6;1;15;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;87;0;85;0
WireConnection;87;1;88;0
WireConnection;87;2;89;0
WireConnection;104;0;96;2
WireConnection;104;1;102;0
WireConnection;116;0;6;0
WireConnection;75;1;24;0
WireConnection;75;3;28;0
WireConnection;97;0;87;0
WireConnection;97;1;104;0
WireConnection;79;0;78;0
WireConnection;79;1;76;0
WireConnection;189;0;97;0
WireConnection;189;1;190;0
WireConnection;80;0;75;0
WireConnection;80;1;79;0
WireConnection;46;0;34;0
WireConnection;46;1;47;0
WireConnection;32;0;80;0
WireConnection;11;0;64;0
WireConnection;90;0;189;0
WireConnection;90;1;91;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;33;0;32;0
WireConnection;33;1;46;0
WireConnection;93;0;92;0
WireConnection;93;1;90;0
WireConnection;42;0;43;0
WireConnection;42;1;6;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;94;0;93;0
WireConnection;81;0;33;0
WireConnection;23;0;42;0
WireConnection;23;1;10;0
WireConnection;193;0;191;0
WireConnection;197;0;195;0
WireConnection;180;0;145;0
WireConnection;178;0;23;0
WireConnection;178;1;177;0
WireConnection;149;0;152;0
WireConnection;213;0;210;0
WireConnection;145;0;186;0
WireConnection;145;1;153;0
WireConnection;194;0;192;0
WireConnection;206;0;199;0
WireConnection;206;1;201;0
WireConnection;205;0;202;0
WireConnection;205;1;203;0
WireConnection;185;0;218;0
WireConnection;185;1;181;0
WireConnection;216;0;215;0
WireConnection;216;2;226;0
WireConnection;122;0;180;0
WireConnection;208;0;205;0
WireConnection;228;0;216;0
WireConnection;228;1;229;0
WireConnection;215;0;214;0
WireConnection;215;1;213;1
WireConnection;215;2;213;2
WireConnection;215;3;213;3
WireConnection;214;0;213;0
WireConnection;214;1;212;0
WireConnection;200;0;196;0
WireConnection;200;1;198;0
WireConnection;212;0;211;0
WireConnection;212;1;211;1
WireConnection;204;0;201;0
WireConnection;204;1;200;0
WireConnection;196;0;193;0
WireConnection;210;0;209;0
WireConnection;210;1;208;0
WireConnection;143;0;23;0
WireConnection;143;1;95;0
WireConnection;143;2;176;0
WireConnection;218;0;106;0
WireConnection;218;1;217;0
WireConnection;218;2;219;0
WireConnection;209;0;206;0
WireConnection;209;1;204;0
WireConnection;147;0;149;0
WireConnection;223;0;221;0
WireConnection;186;0;185;0
WireConnection;106;1;216;0
WireConnection;38;0;56;0
WireConnection;38;1;37;0
WireConnection;217;1;228;0
WireConnection;199;0;195;0
WireConnection;199;1;197;0
WireConnection;198;0;196;0
WireConnection;211;0;207;0
WireConnection;177;0;175;0
WireConnection;152;0;7;0
WireConnection;225;0;223;0
WireConnection;221;0;227;2
WireConnection;221;1;222;0
WireConnection;226;0;225;0
WireConnection;195;0;194;0
WireConnection;0;13;143;0
ASEEND*/
//CHKSM=92325F61B853704B6A442B8C4C1C8B55B6A13EE8