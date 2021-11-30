// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon/Plant"
{
	Properties
	{
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		[Toggle(_USEDIFFUSEMAP_ON)] _UseDiffuseMap("Use Diffuse Map?", Float) = 1
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,0)
		[Toggle(_USENORMALMAP_ON)] _UseNormalMap("Use Normal Map?", Float) = 0
		_NormalMap("Normal Map", 2D) = "bump" {}
		[HDR]_RimColor("Rim Color", Color) = (1,1,1,0)
		_RimPower("Rim Power", Range( 0 , 20)) = 2
		_RimOffset("RimOffset", Range( 0 , 1)) = 0
		_Gloss1("Gloss", Range( 0 , 10)) = 0.1
		_T_SpecularMask("T_SpecularMask", 2D) = "white" {}
		_SpecularOffset1("Specular Offset", Range( 0 , 0.99)) = 0.98
		_SpecularMaskIntensity1("Specular Mask Intensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Grass"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USENORMALMAP_ON
		#pragma shader_feature_local _USEDIFFUSEMAP_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform float4 _DiffuseColor;
		uniform sampler2D _DiffuseMap;
		uniform float4 _DiffuseMap_ST;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _T_SpecularMask;
		uniform float _SpecularMaskIntensity1;
		uniform float _SpecularOffset1;
		uniform float _Gloss1;

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
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			#ifdef _USEDIFFUSEMAP_ON
				float4 staticSwitch291 = tex2D( _DiffuseMap, uv_DiffuseMap );
			#else
				float4 staticSwitch291 = _DiffuseColor;
			#endif
			float4 Diffuse293 = staticSwitch291;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			#ifdef _USENORMALMAP_ON
				float3 staticSwitch60 = saturate( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) );
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
			float2 temp_cast_1 = (saturate( (NdotL77*0.5 + 0.5) )).xx;
			float4 tex2DNode6 = tex2D( _ToonRamp, temp_cast_1 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi11 = gi;
			float3 diffNorm11 = WorldNormalVector( i , Normal54 );
			gi11 = UnityGI_Base( data, 1, diffNorm11 );
			float3 indirectDiffuse11 = gi11.indirect.diffuse + diffNorm11 * 0.0001;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult324 = normalize( ( ase_worldlightDir + ase_worldViewDir ) );
			float3 HalfVector325 = normalizeResult324;
			float dotResult305 = dot( HalfVector325 , Normal54 );
			float4 color318 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			c.rgb = ( ( ( Diffuse293 * tex2DNode6 ) * ( ase_lightColor * float4( ( indirectDiffuse11 + ase_lightAtten ) , 0.0 ) ) ) + ( ( ( saturate( tex2D( _T_SpecularMask, i.uv_texcoord ).r ) * _SpecularMaskIntensity1 ) * step( _SpecularOffset1 , pow( saturate( dotResult305 ) , ( _Gloss1 * 0.1 ) ) ) ) * color318 ) ).rgb;
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
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			#ifdef _USENORMALMAP_ON
				float3 staticSwitch60 = saturate( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) );
			#else
				float3 staticSwitch60 = ase_worldNormal;
			#endif
			float3 Normal54 = staticSwitch60;
			float3 worldSpaceViewDir267 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
			float3 normalizeResult268 = normalize( worldSpaceViewDir267 );
			float dotResult265 = dot( Normal54 , normalizeResult268 );
			o.Emission = ( pow( saturate( ( ( 1.0 - saturate( dotResult265 ) ) - _RimOffset ) ) , _RimPower ) * _RimColor ).rgb;
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
0;30.66667;1706.667;1009;1484.949;-1431.202;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;62;-3263.962,-6.106903;Inherit;False;1125.438;459.0918;Normal;6;53;61;60;54;187;188;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;53;-3246.76,212.398;Inherit;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;0;False;0;False;-1;None;b1dacac67bfede7439a7ecb50d1ebb65;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;320;-2103.025,1023.389;Inherit;False;845;396;HalfVector;5;325;324;323;322;321;HalfVector;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;187;-2916.036,217.4299;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;61;-2899.352,49.20903;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;188;-2681.829,218.3428;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;321;-2009.022,1235.389;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;322;-2053.023,1073.389;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;60;-2586.375,45.1869;Inherit;False;Property;_UseNormalMap;Use Normal Map?;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;323;-1798.02,1168.389;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-2333.229,175.1062;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2013,31.00003;Inherit;False;540.401;320.6003;Comment;4;3;2;55;77;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1156.46,768;Inherit;False;1617.938;553.8222;;13;266;268;265;269;272;270;275;271;273;267;298;299;301;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;324;-1654.45,1168.463;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1973.244,75.51054;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;302;-1180.988,1519.706;Inherit;False;1753.239;565.3416;Comment;16;316;315;314;313;312;311;310;309;308;306;305;304;303;300;318;326;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;267;-1145.219,952.4682;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-2001.799,204.1998;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;-1486.02,1164.389;Inherit;False;HalfVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1143.099,-115.6995;Inherit;False;723.599;290;Also know as Lambert Wrap or Half Lambert;3;5;4;15;Diffuse Wrap;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1777.798,144.5998;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;-1130.987,1720.824;Inherit;False;325;HalfVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;-1086.27,831.3211;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;268;-921.0502,952.4311;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;296;-3171.04,532.6431;Inherit;False;973.855;474.2835;Comment;4;290;294;291;293;Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;303;-1130.232,1847.214;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;294;-2996.835,582.6426;Inherit;False;Property;_DiffuseColor;Diffuse Color;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0,0.9756655,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;290;-3121.04,776.9261;Inherit;True;Property;_DiffuseMap;Diffuse Map;3;0;Create;True;0;0;0;False;0;False;-1;None;89670b321d3e91a41ad067699c2e6d6f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;52;-874.676,256.1136;Inherit;False;812;304;Comment;6;7;8;11;10;12;64;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;305;-928.0928,1767.355;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-1080.945,1950.064;Inherit;False;Property;_Gloss1;Gloss;10;0;Create;True;0;0;0;False;0;False;0.1;0.32;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;265;-780.5047,836.2599;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;306;-537.0145,1598.185;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1660.97,147.0111;Inherit;False;NdotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1074.099,75.30051;Float;False;Constant;_WrapperValue;Wrapper Value;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-774.1162,1956.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-836.0431,415.1302;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;269;-587.0118,869.8395;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;4;-826.6974,-56.69949;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;309;-780.6998,1767.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;300;-290.8772,1570.977;Inherit;True;Property;_T_SpecularMask;T_SpecularMask;11;0;Create;True;0;0;0;False;0;False;-1;None;507141fada9b9ec49aa8e196687aa810;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;291;-2722.798,753.006;Inherit;False;Property;_UseDiffuseMap;Use Diffuse Map?;2;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;117;-331.2315,-359.3239;Inherit;False;781.1381;505.0234;Comment;4;42;6;116;295;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;301;-546.0574,980.0619;Inherit;False;Property;_RimOffset;RimOffset;9;0;Create;True;0;0;0;False;0;False;0;0.21;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-593.4999,-56.89988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;311;-103.7787,1767.325;Inherit;False;Property;_SpecularMaskIntensity1;Specular Mask Intensity;13;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;11;-650.6127,420.1136;Inherit;False;Tangent;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-591.4774,1745.282;Inherit;False;Property;_SpecularOffset1;Specular Offset;12;0;Create;True;0;0;0;False;0;False;0.98;0;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;7;-741.7271,490.4446;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;-2421.185,753.8815;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;313;33.95943,1624.28;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;270;-425.4322,869.8118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;312;-623.8074,1855.251;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;8;-720.676,302.1136;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;6;-281.2316,-84.30046;Inherit;True;Property;_ToonRamp;Toon Ramp;1;0;Create;True;0;0;0;False;0;False;-1;None;8008c1b7ec5390146b51f74f817bb5b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-417.2741,420.1064;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;-177.653,-230.389;Inherit;False;293;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;215.58,1623.691;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;298;-268.7914,870.5941;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;314;-330.8824,1831.048;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-294.5412,302.7826;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;318;250.1542,1913.958;Inherit;False;Constant;_SpecularColor;Specular Color;13;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;75.47929,-99.83525;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;299;-134.2152,872.3667;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-195.4457,1044.528;Inherit;False;Property;_RimPower;Rim Power;8;0;Create;True;0;0;0;False;0;False;2;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;410.254,1805.472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;625.9032,1805.239;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;386.9452,150.9736;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2013,545;Inherit;False;507.201;385.7996;Comment;3;37;38;56;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;271;103.7941,908.7507;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;275;131.718,1032.141;Float;False;Property;_RimColor;Rim Color;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;317;839.6721,835.9067;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;37;-1917,753;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;152;-482.37,581.6583;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-120.498,576.3309;Inherit;False;shadowArea;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;332.0099,906.6482;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;70.56543,29.9287;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1954.282,631.3028;Inherit;False;54;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;149;-298.5397,581.3564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-1661,673;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1128.867,596.8581;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toon/Plant;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Grass;;Geometry;ForwardOnly;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0.1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;187;0;53;0
WireConnection;188;0;187;0
WireConnection;60;1;61;0
WireConnection;60;0;188;0
WireConnection;323;0;322;0
WireConnection;323;1;321;0
WireConnection;54;0;60;0
WireConnection;324;0;323;0
WireConnection;325;0;324;0
WireConnection;3;0;55;0
WireConnection;3;1;2;0
WireConnection;268;0;267;0
WireConnection;305;0;304;0
WireConnection;305;1;303;0
WireConnection;265;0;266;0
WireConnection;265;1;268;0
WireConnection;77;0;3;0
WireConnection;326;0;308;0
WireConnection;269;0;265;0
WireConnection;4;0;77;0
WireConnection;4;1;5;0
WireConnection;4;2;5;0
WireConnection;309;0;305;0
WireConnection;300;1;306;0
WireConnection;291;1;294;0
WireConnection;291;0;290;0
WireConnection;15;0;4;0
WireConnection;11;0;64;0
WireConnection;293;0;291;0
WireConnection;313;0;300;1
WireConnection;270;0;269;0
WireConnection;312;0;309;0
WireConnection;312;1;326;0
WireConnection;6;1;15;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;315;0;313;0
WireConnection;315;1;311;0
WireConnection;298;0;270;0
WireConnection;298;1;301;0
WireConnection;314;0;310;0
WireConnection;314;1;312;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;42;0;295;0
WireConnection;42;1;6;0
WireConnection;299;0;298;0
WireConnection;316;0;315;0
WireConnection;316;1;314;0
WireConnection;319;0;316;0
WireConnection;319;1;318;0
WireConnection;23;0;42;0
WireConnection;23;1;10;0
WireConnection;271;0;299;0
WireConnection;271;1;272;0
WireConnection;317;0;23;0
WireConnection;317;1;319;0
WireConnection;152;0;7;0
WireConnection;147;0;149;0
WireConnection;273;0;271;0
WireConnection;273;1;275;0
WireConnection;116;0;6;0
WireConnection;149;0;152;0
WireConnection;38;0;56;0
WireConnection;38;1;37;0
WireConnection;0;2;273;0
WireConnection;0;13;317;0
ASEEND*/
//CHKSM=1982F7125A6FE05F61C8960C6303A8F59AF834E5