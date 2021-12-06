Shader "Water/Gerstner"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 10
		_Refraction("Refraction", Float) = 1.333
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Depth("Depth", Range( 0 , 200)) = 20
		_Falloff("Falloff", Range( 0 , 1)) = 0.2
		_DepthFadeDistance("Depth Fade Distance", Range( 0 , 5)) = 0
		[HDR]_ShallowWater("Shallow Water", Color) = (0,1.372549,1.286275,1)
		[HDR]_DeepWater("Deep Water", Color) = (0,0.1803922,0.2509804,1)
		[HideInInspector] __dirty( "", Int ) = 1
		
		[Header(Waves)] _Prop1 ("Prop1", Float) = 0 // Dir, Steepness, Wavelength
        _WaveA ("Wave A", Vector) = (1, 0, 0.5, 10)
        _WaveB ("Wave B", Vector) = (0, 1, 0.25, 20)
        _WaveC ("Wave C", Vector) = (1, 1, 0.15, 10)
		_WaveD ("Wave C", Vector) = (1, 1, 0.15, 10)
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#pragma surface surf Standard alpha:fade keepalpha finalcolor:RefractionF noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _ShallowWater;
		uniform float4 _DeepWater;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _Falloff;
		uniform float _DepthFadeDistance;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _Refraction;
		uniform float _TessValue;

        float4 _WaveA, _WaveB, _WaveC, _WaveD;

		float4 tessFunction( )
		{
			return _TessValue;
		}
        float3 GerstnerWave (float4 wave, float3 p, inout float3 tangent, inout float3 binormal)
        {
            float steepness = wave.z;
            float wavelength = wave.w;
            float k = 2 * UNITY_PI / wavelength;
            float c = sqrt(9.8 / k);
            float2 d = normalize(wave.xy);
            float f = k * (dot(d, p.xz) - c * _Time.y);
            float a = steepness / k;
        
            tangent += float3(
                -d.x * d.x * steepness * sin(f),
                d.x * steepness * cos(f),
                -d.x * d.y * steepness * sin(f)
            );
            binormal += float3(
                -d.x * d.y * steepness * sin(f),
                d.y * steepness * cos(f),
                -d.y * d.y * steepness * sin(f)
            );
            return float3(
                d.x * (a * cos(f)),
                a * sin(f),
                d.y * (a * cos(f))
            );
        }
		void vertexDataFunc( inout appdata_full v )
		{
			float3 gridPoint = v.vertex.xyz;
            float3 tangent = float3(1, 0, 0);
            float3 binormal = float3(0, 0, 1);
            float3 p = gridPoint;
            p += GerstnerWave(_WaveA, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveB, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveC, gridPoint, tangent, binormal);
			p += GerstnerWave(_WaveD, gridPoint, tangent, binormal);
            v.vertex.xyz = p;
			v.normal = normalize(cross(binormal, tangent));
		}

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) );
			float2 cameraRefraction = float2( refractionOffset.x, refractionOffset.y );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth96 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth96 = saturate( abs( ( screenDepth96 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
			float lerpResult106 = lerp( 1.0 , _Refraction , distanceDepth96);
			color.rgb = color.rgb + Refraction( i, o, lerpResult106, _ChromaticAberration ) * ( 1 - color.a );
			color.rgb *= _LightColor0.rgb;
			color.rgb += UNITY_LIGHTMODEL_AMBIENT.xyz;
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth69 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV93 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode93 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV93, 3.0 ) );
			float temp_output_94_0 = saturate( ( pow( ( ( eyeDepth69 - ase_screenPosNorm.w ) / _Depth ) , _Falloff ) + fresnelNode93 ) );
			float4 lerpResult100 = lerp( _ShallowWater , _DeepWater , temp_output_94_0);
			o.Albedo = lerpResult100.rgb;
			o.Smoothness = 1.0;
			float screenDepth96 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth96 = saturate( abs( ( screenDepth96 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
			o.Alpha = ( temp_output_94_0 * distanceDepth96 );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
	}
	fallback "diffuse"
}