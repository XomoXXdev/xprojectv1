// Author: robi
// from mta wiki

texture sSceneTexture;
texture sRadialMaskTexture;
float sLengthScale = 1;
float2 sMaskScale = float2(3,1.5);
float2 sMaskOffset = float2(0.5,0.35);
float sVelZoom = 1;
float2 sVelDir = float2(0,0);
float sAmount = 0;

#include "mta-helper.fx"


//---------------------------------------------------------------------
// Sampler for the main texture and sampler for the radial mask
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (sSceneTexture);
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler SamplerMask = sampler_state
{
    Texture = (sRadialMaskTexture);
    AddressU = Clamp;
    AddressV = Clamp;
};


//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
	float3 Position : POSITION;
	float4 Diffuse : COLOR0;
	float2 TexCoord0 : TEXCOORD0;
};


//---------------------------------------------------------------------
// Structure of data sent to the pixel shader
//---------------------------------------------------------------------
struct PSInput
{
	float4 Pos: POSITION;  
	float2 TexCoord0: TEXCOORD0;  
	float2 TexCoord1: TEXCOORD1; 
};  


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Pos = mul(float4(VS.Position, 1), gWorldViewProjection);

    PS.TexCoord0 = VS.TexCoord0;
    PS.TexCoord1 = (VS.TexCoord0 - 0.5) * sMaskScale + sMaskOffset;

    return PS;  
}  

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR  
{
    float2 dir = 0.5 - PS.TexCoord0;

    float lengthAmount = lerp(0.5, 1, sAmount) * sLengthScale;

    if (sVelZoom < 0)
    {
        dir *= sVelZoom * lengthAmount * 2;
        dir += sVelDir * lengthAmount * 2;
    }
    else
    {
        dir += dir * sVelZoom * lengthAmount;
		dir += sVelDir * lengthAmount * 2 * (1 + sVelZoom);
    }
      
    float4 sum = 0;
    float weightTotal = 0;
    for (int i = 0; i < 22; i++)  
    {
        float weight = 1 - (i / 26.0);
        float s = 0.01 + i * 0.005 + i*i*0.0002;
        sum += tex2D(Sampler0, PS.TexCoord0 + dir * s * lengthAmount * 0.9) * weight;
        weightTotal += weight;
    }  
    sum /= weightTotal;
	
	float4 mask = tex2D(SamplerMask, PS.TexCoord1);
    sum.a = min(0.7,mask.a * sAmount);

	return sum;
}  


//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique tec
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
    }
}