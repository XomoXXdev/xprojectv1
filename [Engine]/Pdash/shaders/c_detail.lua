    --
    -- c_detail.lua
    --
     
    ----------------------------------------------------------------
    -- enableDetail
    ----------------------------------------------------------------
    local value = {0.2,           -- reflection
                                    0.8, 0.4,       -- bump mapping
                                    90, }           -- max effect distance
    local refl = true
	local rain = {}
	local effectParts
	local bAllValid
	local bEffectEnabled
	
    function enableDetail()
            if bEffectEnabled then return end
     
            -- Load textures
            detail22Texture = dxCreateTexture('shaders/images/detail22.png', "dxt3")
            detail58Texture = dxCreateTexture('shaders/images/detail58.png', "dxt3")
            detail68Texture = dxCreateTexture('shaders/images/detail68.png', "dxt1")
            detail63Texture = dxCreateTexture('shaders/images/detail63.png', "dxt3")
            dirtyTexture = dxCreateTexture('shaders/images/dirty.png', "dxt3")
            detail04Texture = dxCreateTexture('shaders/images/detail04.png', "dxt3")
            detail29Texture = dxCreateTexture('shaders/images/detail29.png', "dxt3")
            detail55Texture = dxCreateTexture('shaders/images/detail55.png', "dxt3")
            detail35TTexture = dxCreateTexture('shaders/images/detail35T.png', "dxt3")
            textureCube = dxCreateTexture ( 'shaders/images/cube_env256.dds' )     
            textureVol = dxCreateTexture ( 'shaders/images/smallnoise3d.dds' )
     
                           
     
            -- Create shaders
            brickWallShader, tec = getBrickWallShader()
            if brickWallShader then
                    -- Only create the rest if the first one is OK
                    grassShader = getGrassShader()
                    roadShader = getRoadShader()
                    road2Shader = getRoad2Shader()
                    paveDirtyShader = getPaveDirtyShader()
                    paveStretchShader = getPaveStretchShader()
                    barkShader = getBarkShader()
                    rockShader = getRockShader()
                    mudShader = getMudShader()
                    concreteShader = getBrickWallShader()   -- TODO make this better
                    sandShader = getMudShader()             -- TODO make this better
            end
     
            -- Get list of all elements used
            effectParts = {
                                                    detail22Texture, detail58Texture, detail68Texture, detail63Texture, dirtyTexture,
                                                    detail04Texture, detail29Texture, detail55Texture, detail35TTexture,
                                                    brickWallShader, grassShader, roadShader, road2Shader, paveDirtyShader,
                                                    paveStretchShader, barkShader, rockShader, mudShader,
                                                    concreteShader, sandShader
                                            }
     
            -- Check list of all elements used
            bAllValid = true
            for _,part in ipairs(effectParts) do
                    bAllValid = part and bAllValid
            end
     
            bEffectEnabled = true
     
            if not bAllValid then
               
                    disableDetail()
            else
                
     
                    engineApplyShaderToWorldTexture ( roadShader, "*road*" )
                    engineApplyShaderToWorldTexture ( roadShader, "*tar*" )
                    engineApplyShaderToWorldTexture ( roadShader, "*asphalt*" )
                    engineApplyShaderToWorldTexture ( roadShader, "*freeway*" )
                    engineApplyShaderToWorldTexture ( concreteShader, "*wall*" )
                    engineApplyShaderToWorldTexture ( concreteShader, "*floor*" )
                    engineApplyShaderToWorldTexture ( concreteShader, "*bridge*" )
                    engineApplyShaderToWorldTexture ( concreteShader, "*conc*" )
                    engineApplyShaderToWorldTexture ( concreteShader, "*drain*" )
                    engineApplyShaderToWorldTexture ( paveDirtyShader, "*walk*" )
                    engineApplyShaderToWorldTexture ( paveDirtyShader, "*pave*" )
                    engineApplyShaderToWorldTexture ( paveDirtyShader, "*cross*" )
     
                    engineApplyShaderToWorldTexture ( mudShader, "*mud*" )
                    engineApplyShaderToWorldTexture ( mudShader, "*dirt*" )
                    engineApplyShaderToWorldTexture ( rockShader, "*rock*" )
                    engineApplyShaderToWorldTexture ( rockShader, "*stone*" )
                    engineApplyShaderToWorldTexture ( rockShader, "*cliff*" )
                    engineApplyShaderToWorldTexture ( grassShader, "*grass*" )
                    engineApplyShaderToWorldTexture ( grassShader, "desertgryard256" )      -- grass
     
                    engineApplyShaderToWorldTexture ( sandShader, "*sand*" )
                    engineApplyShaderToWorldTexture ( barkShader, "*leave*" )
                    engineApplyShaderToWorldTexture ( barkShader, "*log*" )
                    engineApplyShaderToWorldTexture ( barkShader, "*bark*" )
     
                    -- Roads
                    engineApplyShaderToWorldTexture ( roadShader, "*carpark*" )
                    engineApplyShaderToWorldTexture ( road2Shader, "*hiway*" )
                    engineApplyShaderToWorldTexture ( roadShader, "*junction*" )
                    engineApplyShaderToWorldTexture ( paveStretchShader, "snpedtest*" )
     
                    -- Pavement
                    engineApplyShaderToWorldTexture ( paveStretchShader, "sidelatino*" )
                    engineApplyShaderToWorldTexture ( paveStretchShader, "sjmhoodlawn41" )
     
                    -- Remove detail from LOD models etc.
                    for i,part in ipairs(effectParts) do
                            if getElementType(part) == "shader" then
                                    engineRemoveShaderFromWorldTexture ( part, "tx*" )
                                    engineRemoveShaderFromWorldTexture ( part, "lod*" )
                            end
                    end
                   
     
     
            end
     
    end
     
     
    ----------------------------------------------------------------
    -- disableDetail
    ----------------------------------------------------------------
    function disableDetail()
            if not bEffectEnabled then return end
     
            -- Destroy all parts
            for _,part in ipairs(effectParts) do
                    if part then
                            destroyElement( part )
                    end
            end
            effectParts = {}
            bAllValid = false
     
            -- Flag effect as stopped
            bEffectEnabled = false
    end
     
     
    ----------------------------------------------------------------
    -- All the shaders
    ----------------------------------------------------------------
    function getBrickWallShader()
            return getMakeShader( getBrickWallSettings () )
    end
     
    function getGrassShader()
            return getMakeShader( getGrassSettings () )
    end
     
    function getRoadShader()
            return getMakeShader( getRoadSettings () )
    end
     
    function getRoad2Shader()
            return getMakeShader( getRoad2Settings () )
    end
     
    function getPaveDirtyShader()
            return getMakeShader( getPaveDirtySettings () )
    end
     
    function getPaveStretchShader()
            return getMakeShader( getPaveStretchSettings () )
    end
     
    function getBarkShader()
            return getMakeShader( getBarkSettings () )
    end
     
    function getRockShader()
            return getMakeShader( getRockSettings () )
    end
     
    function getMudShader()
            return getMakeShader( getMudSettings () )
    end
     
    function getMakeShader(v)
            --  Create shader with a draw range of 100 units
            local shader,tec = dxCreateShader ( "shaders/detail.fx", 1, 100 )
            if shader then
                    dxSetShaderValue( shader, "sDetailTexture", v.texture )
                    dxSetShaderValue( shader, "sDetailScale", v.detailScale )
                    dxSetShaderValue( shader, "sFadeStart", v.sFadeStart )
                    dxSetShaderValue( shader, "sFadeEnd", v.sFadeEnd )
                    dxSetShaderValue( shader, "sStrength", v.sStrength )
                   
                   
                    ----------------------------------------------------------------------------------------------------------------------
                    if (v.texture == detail68Texture or v.texture == detail63Texture or v.texture == detail04Texture or v.texture == dirtyTexture) and refl == true then
                            dxSetShaderValue ( shader, "sReflectionTexture", textureCube )
                            dxSetShaderValue ( shader, "sRandomTexture", textureVol )
                            dxSetShaderValue ( shader, "sValue", value )
                        
							rain[shader] = false
                            setTimer (deszcz, 1000, 0, shader)
                    end
                    -----------------------------------------------------------------------------------------------------------------------
                   
     
            end
            return shader,tec
    end
     
     
    -- brick wall type thing
    ---------------------------------
    function getBrickWallSettings ()
            local v = {}
            v.texture=detail22Texture
            v.detailScale=3
            v.sFadeStart=80
            v.sFadeEnd=100
            v.sStrength=0.6
            return v
    end
    ---------------------------------
     
    -- grass
    ---------------------------------
    function getGrassSettings ()
            local v = {}
            v.texture=detail58Texture
            v.detailScale=2
            v.sFadeStart=80
            v.sFadeEnd=100
            v.sStrength=0.6
            return v
    end
    ---------------------------------
     
    -- tree bark
    ---------------------------------
    function getBarkSettings ()
            local v = {}
            v.texture=detail29Texture
            v.detailScale=1
            v.sFadeStart=80
            v.sFadeEnd=100
            v.sStrength=0.6
            return v
    end
    ---------------------------------
     
    -- rock
    ---------------------------------
    function getRockSettings ()
            local v = {}
            v.texture=detail55Texture
            v.detailScale=1
            v.sFadeStart=80
            v.sFadeEnd=100
            v.sStrength=0.5
            return v
    end
    ---------------------------------
     
    -- mud
    ---------------------------------
    function getMudSettings ()
            local v = {}
            v.texture=detail35TTexture
            v.detailScale=1
            v.sFadeStart=80
            v.sFadeEnd=100
            v.sStrength=0.5
            return v
    end
    ---------------------------------
     
    -- road
    ---------------------------------
    function getRoadSettings ()
            local v = {}
            v.texture=detail68Texture
            v.detailScale=1
            v.sFadeStart=60
            v.sFadeEnd=100
            v.sStrength=0.6
            return v
    end
    ---------------------------------
     
    -- road2
    ---------------------------------
    function getRoad2Settings ()
            local v = {}
            v.texture=detail63Texture
            v.detailScale=1
            v.sFadeStart=60
            v.sFadeEnd=100
            v.sStrength=0.7
            return v
    end
    ---------------------------------
     
    -- dirty pave
    ---------------------------------
    function getPaveDirtySettings ()
            local v = {}
            v.texture=dirtyTexture
            v.detailScale=1
            v.sFadeStart=60
            v.sFadeEnd=100
            v.sStrength=0.4
            return v
    end
    ---------------------------------
     
    -- stretch pave
    ---------------------------------
    function getPaveStretchSettings ()
            local v = {}
            v.texture=detail04Texture
            v.detailScale=1
            v.sFadeStart=60
            v.sFadeEnd=100
            v.sStrength=0.3
            return v
    end
    ---------------------------------
     
     
    function deszcz (sh)
                    local w = getWeather()
            if (w == 8 or w == 16) and rain[sh] == false then
                            rain[sh] = true
                            dxSetShaderValue( sh, "g_bRainy", true )
            elseif ((w < 8 or w > 8) and (w < 16 or w > 16)) and rain[sh] == true then
                            rain[sh] = false
                            dxSetShaderValue( sh, "g_bRainy", false )
            else
            end
    end
addEvent("onClientSwitchDetail",true)
addEventHandler("onClientSwitchDetail",getLocalPlayer(),function(state)
	if state then
		enableDetail()
	else
		disableDetail()
	end
end)