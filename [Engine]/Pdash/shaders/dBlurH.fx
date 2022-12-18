// Author: Ren712 and robi

//---------------------------------------------------------------------
// Settings
//---------------------------------------------------------------------
texture sTex0 : TEX0;
texture gDepthBuffer : DEPTHBUFFER;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
float gDepthFactor = 0.002;
float blurDiv = 9.3;
float gblurFactor = 0.0025;
float gDepthIntensity = 0.3;
static const float Weights[9] = {0.951, 0.880, 0.770, 0.630, 0.500, 0.370, 0.230, 0.120, 0.049};

#include "mta-helper.fx"


//---------------------------------------------------------------------
// Sampler
//---------------------------------------------------------------------
sampler SamplerDepth = sampler_state
{
	Texture = (gDepthBuffer);
	AddressU = Clamp;
	AddressV = Clamp;
};

sampler2D Sampler0 = sampler_state
{
	Texture = (sTex0);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Clamp;
	AddressV = Clamp;
};


//---------------------------------------------------------------------
// Structure of data sent to the pixel shader
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};


//-----------------------------------------------------------------------------
//-- Get value from the depth buffer
//-- Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//-----------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
	#if IS_DEPTHBUFFER_RAWZ
		float3 rawval = floor(255.0 * texel.arg + 0.5);
		float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
		return dot(rawval, ValueScaler / 255.0);
	#else
		return texel.r;
	#endif
}


//-----------------------------------------------------------------------------
//-- Use the last scene projecion matrix to linearize the depth value a bit more
//-----------------------------------------------------------------------------
float Linearize(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}


//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float BufferValue = FetchDepthBufferValue( PS.TexCoord.xy );
	float Depth = Linearize( BufferValue );
   	float4 Color = tex2D(Sampler0, PS.TexCoord);
	float4 Texel = Color;

	for (int i=1; i < 10; i++)
	{
			Color += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y-(gblurFactor*i*gDepthIntensity*2))) * Weights[i-1];
			Color += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y+(gblurFactor*i*gDepthIntensity*2))) * Weights[i-1];
	}

	Color /= blurDiv;
	Depth*=gDepthFactor;
	if (Depth>1)
		Depth=1;
	float4 outPut=lerp(Texel,Color,Depth);
    return outPut;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique depth_blurh
{
    pass P0
    {
        //VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
    }
}