// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TidalFlask/Foliage Wind Standard Advanced Lit"
{
	Properties
	{
		_BaseTexture("Base Texture", 2D) = "white" {}
		_BaseTexColorTint("Base Tex Color Tint", Color) = (1,1,1,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_GroundFadeColor("Ground Fade Color", Color) = (0.3137255,0.3960785,0.1137255,1)
		_GroundFadeHeight("Ground Fade Height", Range( -5 , 0)) = -1
		_GroundFadeContrast("Ground Fade Contrast", Range( 0 , 2)) = 1
		_WindStrength("Wind Strength", Range( 0 , 1)) = 0.4
		_WindScale("Wind Scale", Range( 0 , 1)) = 0.4
		_WindSpeed("Wind Speed", Vector) = (2,1,0,0)
		_WindTintOpacity("Wind Tint Opacity", Range( 0 , 1)) = 0.25
		_WindTintContrast("Wind Tint Contrast", Range( 1 , 5)) = 1
		_WindTintScale("Wind Tint Scale", Range( 0 , 0.5)) = 0.12
		_WindTintSpeed("Wind Tint Speed", Vector) = (-3,1,0,0)
		_DistanceFadeColor("Distance Fade Color", Color) = (0.5333334,0.6745098,0.1607843,1)
		_DistanceFadeStart("Distance Fade Start", Float) = 20
		_DistanceFadeEnd("Distance Fade End", Float) = 50
		_DistanceFadeOpacity("Distance Fade Opacity", Range( 0 , 1)) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float eyeDepth;
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

		uniform float2 _WindSpeed;
		uniform float _WindScale;
		uniform float _WindStrength;
		uniform float4 _BaseTexColorTint;
		uniform sampler2D _BaseTexture;
		uniform float4 _BaseTexture_ST;
		uniform float2 _WindTintSpeed;
		uniform float _WindTintScale;
		uniform float _WindTintOpacity;
		uniform float _WindTintContrast;
		uniform float4 _GroundFadeColor;
		uniform float _GroundFadeHeight;
		uniform float _GroundFadeContrast;
		uniform float4 _DistanceFadeColor;
		uniform float _DistanceFadeOpacity;
		uniform float _DistanceFadeEnd;
		uniform float _DistanceFadeStart;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 break219 = ase_worldPos;
			float4 appendResult221 = (float4(break219.x , break219.z , 0.0 , 0.0));
			float simplePerlin2D38 = snoise( (( appendResult221 / 2 )*1.0 + float4( ( _Time.y * _WindSpeed ), 0.0 , 0.0 )).xy*_WindScale );
			simplePerlin2D38 = simplePerlin2D38*0.5 + 0.5;
			float3 break49 = ase_worldPos;
			float4 appendResult51 = (float4(( ( ( simplePerlin2D38 - 0.5 ) * _WindStrength ) + break49.x ) , break49.y , break49.z , 0.0));
			float4 lerpResult3 = lerp( float4( ase_worldPos , 0.0 ) , appendResult51 , v.texcoord.xy.y);
			float3 worldToObj1 = mul( unity_WorldToObject, float4( lerpResult3.xyz, 1 ) ).xyz;
			float3 VertexPosition77 = worldToObj1;
			v.vertex.xyz = VertexPosition77;
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

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
			float2 uv_BaseTexture = i.uv_texcoord * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
			float4 tex2DNode4 = tex2D( _BaseTexture, uv_BaseTexture );
			float4 temp_output_98_0 = ( _BaseTexColorTint * tex2DNode4 );
			float4 BaseTexture407 = temp_output_98_0;
			float3 ase_worldPos = i.worldPos;
			float3 break290 = ase_worldPos;
			float4 appendResult291 = (float4(break290.x , break290.z , 0.0 , 0.0));
			float2 _Vector0 = float2(2,0);
			float simplePerlin2D298 = snoise( (( appendResult291 / _Vector0.x )*1.0 + float4( ( _Time.y * ( _WindTintSpeed * 0.2 ) ), 0.0 , 0.0 )).xy*( _WindTintScale * 1.2 ) );
			simplePerlin2D298 = simplePerlin2D298*0.5 + 0.5;
			float3 break254 = ase_worldPos;
			float4 appendResult257 = (float4(break254.x , break254.z , 0.0 , 0.0));
			float simplePerlin2D263 = snoise( (( appendResult257 / _Vector0.x )*1.0 + float4( ( _Time.y * _WindTintSpeed ), 0.0 , 0.0 )).xy*_WindTintScale );
			simplePerlin2D263 = simplePerlin2D263*0.5 + 0.5;
			float clampResult300 = clamp( ( simplePerlin2D298 + simplePerlin2D263 ) , 0.0 , 1.0 );
			float lerpResult242 = lerp( 1.0 , clampResult300 , _WindTintOpacity);
			float clampResult338 = clamp( pow( lerpResult242 , _WindTintContrast ) , 0.0 , 1.0 );
			float3 switchResult415 = (((i.ASEVFace>0)?(float3(0,0,1)):(float3(0,0,-1))));
			UnityGI gi75 = gi;
			float3 diffNorm75 = WorldNormalVector( i , switchResult415 );
			gi75 = UnityGI_Base( data, 1, diffNorm75 );
			float3 indirectDiffuse75 = gi75.indirect.diffuse + diffNorm75 * 0.0001;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult418 = dot( (WorldNormalVector( i , switchResult415 )) , ase_worldlightDir );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_72_0 = ( saturate( ( indirectDiffuse75 + ( max( dotResult418 , 0.0 ) * ase_lightAtten ) ) ) * ase_lightColor.rgb );
			float3 CustomLightingInfo408 = temp_output_72_0;
			float4 CustomLightingWindTint173 = ( BaseTexture407 + float4( ( ( 1.0 - clampResult338 ) * CustomLightingInfo408 ) , 0.0 ) );
			float clampResult333 = clamp( ( pow( ( 1.0 - i.uv_texcoord.y ) , ( 1.0 - _GroundFadeHeight ) ) * _GroundFadeContrast ) , 0.0 , 1.0 );
			float4 lerpResult315 = lerp( CustomLightingWindTint173 , _GroundFadeColor , clampResult333);
			float4 GroundColorGradient319 = lerpResult315;
			float4 temp_cast_6 = (0.0).xxxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float4 staticSwitch111 = _DistanceFadeColor;
			#else
				float4 staticSwitch111 = temp_cast_6;
			#endif
			float cameraDepthFade83 = (( i.eyeDepth -_ProjectionParams.y - _DistanceFadeStart ) / _DistanceFadeEnd);
			float4 lerpResult84 = lerp( GroundColorGradient319 , staticSwitch111 , ( _DistanceFadeOpacity * saturate( cameraDepthFade83 ) ));
			float4 CustomLightingAndFade169 = lerpResult84;
			float4 CustomLighting167 = ( CustomLightingAndFade169 * float4( temp_output_72_0 , 0.0 ) );
			c.rgb = CustomLighting167.rgb;
			c.a = 1;
			clip( tex2DNode4.a - _Cutoff );
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
			float2 uv_BaseTexture = i.uv_texcoord * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
			float4 tex2DNode4 = tex2D( _BaseTexture, uv_BaseTexture );
			float4 temp_output_98_0 = ( _BaseTexColorTint * tex2DNode4 );
			o.Albedo = temp_output_98_0.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float3 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v, customInputData );
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
				o.customPack1.z = customInputData.eyeDepth;
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
				surfIN.eyeDepth = IN.customPack1.z;
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
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18912
1735;4;1694;1362;1721.351;1823.159;1.966367;True;False
Node;AmplifyShaderEditor.CommentaryNode;307;-784.8948,83.04046;Inherit;False;3939.225;1352.215;2 similar noises, multiplied values to make them move differently, add to combine them, so the overall noise is not constant;36;338;336;173;168;337;242;243;300;157;299;263;298;296;301;262;259;260;295;261;294;302;291;257;258;306;256;305;254;255;290;253;289;342;343;409;410;wind movement tint;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;90;-1770.437,-1343.694;Inherit;False;3500.173;651.9265;;18;167;80;406;408;72;73;412;405;75;420;419;63;418;416;417;415;414;413;custom lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;289;-727.9875,231.3433;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;253;-730.4856,745.5283;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;413;-1739.654,-1094.022;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;305;-421.6371,501.2833;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;414;-1742.254,-1264.622;Inherit;False;Constant;_Vector3;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;254;-491.0369,747.3573;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector2Node;255;-491.5227,1206.884;Inherit;False;Property;_WindTintSpeed;Wind Tint Speed;12;0;Create;True;0;0;0;False;0;False;-3,1;-3,1.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;290;-488.5359,233.1721;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;258;-226.1302,1143.821;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;291;-318.3923,227.3754;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;257;-307.0373,748.4882;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-224.6585,483.1548;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;256;-250.3442,960.9602;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SwitchByFaceNode;415;-1508.234,-1261.935;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;302;276.4665,499.7336;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;284.2695,1063.42;Inherit;False;Property;_WindTintScale;Wind Tint Scale;11;0;Create;True;0;0;0;False;0;False;0.12;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-28.83037,483.0758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;260;-29.54423,748.8528;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;417;-1240.563,-1094.755;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;294;-34.39238,227.3754;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;416;-1191.929,-1262.273;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-21.49832,1189.915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;473.4455,481.605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;418;-909.4273,-1259.717;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;296;305.5385,227.1394;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;262;282.7275,749.5204;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LightAttenuation;63;-812.0579,-895.7432;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;298;602.6046,222.8375;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;263;600.2706,742.9694;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;419;-732.8576,-1258.374;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;75;-36.8986,-1038.952;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;908.8994,541.3304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;420;-490.6986,-916.6545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;300;1124.602,541.2378;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;1127.098,716.7544;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;967.8816,978.9141;Inherit;False;Property;_WindTintOpacity;Wind Tint Opacity;9;0;Create;True;0;0;0;False;0;False;0.25;0.603;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;405;238.5923,-1039.179;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;412;447.6685,-1041.845;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;337;1353.551,983.0154;Inherit;False;Property;_WindTintContrast;Wind Tint Contrast;10;0;Create;True;0;0;0;False;0;False;1;1;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;73;234.2935,-900.3678;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;242;1333.357,721.847;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;96.0648,-569.1783;Inherit;False;Property;_BaseTexColorTint;Base Tex Color Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;645.6019,-1041.646;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;336;1614.555,729.1675;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;27.80743,-385.3248;Inherit;True;Property;_BaseTexture;Base Texture;0;0;Create;True;0;0;0;False;0;False;-1;d15311635b9addf4f94b4c5df2799ab6;8c80f401599d6904a97cc7995352df7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;331;-796.4026,1593.034;Inherit;False;2445.04;808.2798;Comment;12;319;315;316;314;333;394;325;317;399;404;395;396;ground tint;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;338;1864.609,719.0894;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-5038.34,96.44376;Inherit;False;3975.085;998.6667;;23;77;1;3;54;51;52;48;41;49;50;39;42;38;35;46;34;225;222;33;44;221;219;218;wind movement;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;373.9261,-404.178;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;408;905.9928,-866.3229;Inherit;False;CustomLightingInfo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;317;-749.8213,1994.129;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;407;640.3561,-305.1542;Inherit;False;BaseTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;218;-4917.365,229.5107;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;410;1946.679,954.3416;Inherit;False;408;CustomLightingInfo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;343;2048.613,723.6094;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-763.4298,2246.338;Inherit;False;Property;_GroundFadeHeight;Ground Fade Height;4;0;Create;True;0;0;0;False;0;False;-1;0;-5;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;219;-4677.92,231.3396;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;168;2265.835,563.7277;Inherit;False;407;BaseTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;404;-455.3729,2251.752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;399;-458.8683,1992.404;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;409;2328.679,720.3416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;342;2569.458,701.2905;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;222;-4489.383,448.3716;Inherit;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;396;-264.4489,2248.338;Inherit;False;Property;_GroundFadeContrast;Ground Fade Contrast;5;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-4263.212,501.8857;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;325;-230.8233,1994.222;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;44;-4269.143,616.3005;Inherit;False;Property;_WindSpeed;Wind Speed;8;0;Create;True;0;0;0;False;0;False;2,1;3,1.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;221;-4507.776,225.5426;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;73.62425,1994.165;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-4051.184,500.4236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;173;2851.828,701.0938;Inherit;False;CustomLightingWindTint;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;225;-4223.775,225.5426;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;91;-805.1366,2554.66;Inherit;False;2159.169;567.1646;;12;169;84;111;109;85;108;89;112;83;86;87;320;distance fade to color;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;316;226.0757,1737.878;Inherit;False;Property;_GroundFadeColor;Ground Fade Color;3;0;Create;True;0;0;0;False;0;False;0.3137255,0.3960785,0.1137255,1;0.3372549,0.4196079,0.145098,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;333;330.3447,1992.093;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;-3883.848,225.3067;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;182.8716,1642.96;Inherit;False;173;CustomLightingWindTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-749.8009,2921.177;Inherit;False;Property;_DistanceFadeEnd;Distance Fade End;15;0;Create;True;0;0;0;False;0;False;50;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-752.3098,3027.159;Inherit;False;Property;_DistanceFadeStart;Distance Fade Start;14;0;Create;True;0;0;0;False;0;False;20;10.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-3841.686,500.2346;Inherit;False;Property;_WindScale;Wind Scale;7;0;Create;True;0;0;0;False;0;False;0.4;0.158;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-3621.201,217.9587;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;83;-410.3142,2985.913;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;315;571.8749,1721.381;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;89;-147.2152,2987.617;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-3324.725,503.1466;Inherit;False;Property;_WindStrength;Wind Strength;6;0;Create;True;0;0;0;False;0;False;0.4;0.346;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;66.58377,2938.868;Inherit;False;Property;_DistanceFadeOpacity;Distance Fade Opacity;16;0;Create;True;0;0;0;False;0;False;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-3323.864,225.2826;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-310.9655,2674.239;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-408.1628,2764.808;Inherit;False;Property;_DistanceFadeColor;Distance Fade Color;13;0;Create;True;0;0;0;False;0;False;0.5333334,0.6745098,0.1607843,1;0.5333334,0.6745098,0.1607843,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;1229.656,1715.022;Inherit;False;GroundColorGradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3317.243,713.5375;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-3054.057,225.2896;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;393.1045,2967.058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;111;-104.453,2766.763;Inherit;False;Property;_Keyword0;Keyword 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;49;-3045.079,710.4855;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;320;301.3001,2681.306;Inherit;False;319;GroundColorGradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;84;656.5492,2748.321;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-2794.242,687.1675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;1012.613,2741.242;Inherit;False;CustomLightingAndFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2633.382,710.9655;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-2398.239,922.8834;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;54;-2394.091,497.9655;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;3;-2108.269,687.9495;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;406;905.1004,-1084.444;Inherit;False;169;CustomLightingAndFade;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1242.129,-1062.528;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformPositionNode;1;-1778.393,683.4116;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1421.055,684.0695;Inherit;False;VertexPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;1439.19,-1059.094;Inherit;False;CustomLighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;1525.94,-172.0761;Inherit;False;167;CustomLighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;1527.912,-92.77522;Inherit;False;77;VertexPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;32;1911.958,-397.672;Float;False;True;-1;6;;0;0;CustomLighting;TidalFlask/Foliage Wind Standard Advanced Lit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;1;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;254;0;253;0
WireConnection;290;0;289;0
WireConnection;291;0;290;0
WireConnection;291;1;290;2
WireConnection;257;0;254;0
WireConnection;257;1;254;2
WireConnection;306;0;255;0
WireConnection;306;1;305;0
WireConnection;415;0;414;0
WireConnection;415;1;413;0
WireConnection;295;0;258;0
WireConnection;295;1;306;0
WireConnection;260;0;257;0
WireConnection;260;1;256;1
WireConnection;294;0;291;0
WireConnection;294;1;256;1
WireConnection;416;0;415;0
WireConnection;259;0;258;0
WireConnection;259;1;255;0
WireConnection;301;0;261;0
WireConnection;301;1;302;0
WireConnection;418;0;416;0
WireConnection;418;1;417;0
WireConnection;296;0;294;0
WireConnection;296;2;295;0
WireConnection;262;0;260;0
WireConnection;262;2;259;0
WireConnection;298;0;296;0
WireConnection;298;1;301;0
WireConnection;263;0;262;0
WireConnection;263;1;261;0
WireConnection;419;0;418;0
WireConnection;75;0;415;0
WireConnection;299;0;298;0
WireConnection;299;1;263;0
WireConnection;420;0;419;0
WireConnection;420;1;63;0
WireConnection;300;0;299;0
WireConnection;405;0;75;0
WireConnection;405;1;420;0
WireConnection;412;0;405;0
WireConnection;242;0;243;0
WireConnection;242;1;300;0
WireConnection;242;2;157;0
WireConnection;72;0;412;0
WireConnection;72;1;73;1
WireConnection;336;0;242;0
WireConnection;336;1;337;0
WireConnection;338;0;336;0
WireConnection;98;0;97;0
WireConnection;98;1;4;0
WireConnection;408;0;72;0
WireConnection;407;0;98;0
WireConnection;343;0;338;0
WireConnection;219;0;218;0
WireConnection;404;0;395;0
WireConnection;399;0;317;2
WireConnection;409;0;343;0
WireConnection;409;1;410;0
WireConnection;342;0;168;0
WireConnection;342;1;409;0
WireConnection;325;0;399;0
WireConnection;325;1;404;0
WireConnection;221;0;219;0
WireConnection;221;1;219;2
WireConnection;394;0;325;0
WireConnection;394;1;396;0
WireConnection;34;0;33;0
WireConnection;34;1;44;0
WireConnection;173;0;342;0
WireConnection;225;0;221;0
WireConnection;225;1;222;1
WireConnection;333;0;394;0
WireConnection;35;0;225;0
WireConnection;35;2;34;0
WireConnection;38;0;35;0
WireConnection;38;1;46;0
WireConnection;83;0;87;0
WireConnection;83;1;86;0
WireConnection;315;0;314;0
WireConnection;315;1;316;0
WireConnection;315;2;333;0
WireConnection;89;0;83;0
WireConnection;39;0;38;0
WireConnection;319;0;315;0
WireConnection;41;0;39;0
WireConnection;41;1;42;0
WireConnection;109;0;108;0
WireConnection;109;1;89;0
WireConnection;111;1;112;0
WireConnection;111;0;85;0
WireConnection;49;0;50;0
WireConnection;84;0;320;0
WireConnection;84;1;111;0
WireConnection;84;2;109;0
WireConnection;48;0;41;0
WireConnection;48;1;49;0
WireConnection;169;0;84;0
WireConnection;51;0;48;0
WireConnection;51;1;49;1
WireConnection;51;2;49;2
WireConnection;3;0;54;0
WireConnection;3;1;51;0
WireConnection;3;2;52;2
WireConnection;80;0;406;0
WireConnection;80;1;72;0
WireConnection;1;0;3;0
WireConnection;77;0;1;0
WireConnection;167;0;80;0
WireConnection;32;0;98;0
WireConnection;32;10;4;4
WireConnection;32;13;170;0
WireConnection;32;11;78;0
ASEEND*/
//CHKSM=D4AC0B20A01E561A97516EDD342E6A9D4BE3396E