// Author: robi

texture PixelShadTexture; 
float Timer : TIME;
float fNintensity = 0.14;
float fSintensity = 0.07;


sampler2D sampScreen = sampler_state
{
	Texture = <PixelShadTexture>;
	MinFilter = Point;
	MagFilter = Point;
};


float4 ps_main(float2 uv : TEXCOORD0) : COLOR0
{
	float4 cTextureScreen = tex2D(sampScreen, uv.xy);

	float x = uv.x * uv.y * Timer * 1000;
	x = fmod(x, 13) * fmod(x, 123);
	float dx = fmod(x, 0.01);


	float3 cResult = cTextureScreen.rgb + cTextureScreen.rgb * saturate(0.1f + dx.xxx * 100);

	float2 sc;
	sincos(uv.y, sc.x, sc.y);

	cResult += cTextureScreen.rgb * float3(sc.x, sc.y, sc.x) * fSintensity;


	cResult = lerp(cTextureScreen, cResult, saturate(fNintensity));

	return float4(cResult, cTextureScreen.a);
}


technique PostProcess
{
	pass Pass_0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}