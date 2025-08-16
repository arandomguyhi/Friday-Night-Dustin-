local path = 'stages/snowdin_river/'

luaDebugMode = true

function onCreate()
    makeLuaSprite('BG', path..'back', -600, -480)
    scaleObject('BG', 1.5, 1.5, false)
    setScrollFactor('BG', .5, 1)
    setProperty('BG.antialiasing', true)
    addLuaSprite('BG')

    -- PAPYRUS PART
    makeLuaSprite('cliff', path..'Papyrus/cliff', -790, -330)
    scaleObject('cliff', 1.5, 1.5, false)
    setScrollFactor('cliff', .93, 1)
    setProperty('cliff.antialiasing', true)
    addLuaSprite('cliff')

    makeLuaSprite('ground', path..'Papyrus/front', -795, -500)
    scaleObject('ground', 1.7, 1.7, false)
    setProperty('ground.antialiasing', true)
    addLuaSprite('ground')

    makeLuaSprite('trees', path..'Papyrus/trees', -800, -490)
    scaleObject('trees', 1.5, 1.5, false)
    setProperty('trees.antialiasing', true)
    addLuaSprite('trees')

    -- SHADERS 'N SHIT
    createInstance('camCharacters', 'flixel.FlxCamera', {0, 0})
    for x, cam in pairs({'camGame', 'camHUD', 'camOther'}) do callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cam), false}) end
    for x, cam in pairs({'camGame', 'camCharacters', 'camHUD', 'camOther'}) do
        setProperty(cam..'.bgColor', 0x000000)
        callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cam), cam == 'camGame'})
    end
    runHaxeCode("getVar('camCharacters').filters = [];")

    if shadersEnabled then
        initLuaShader('bloom_new')
        makeLuaSprite('bloom_new') setSpriteShader('bloom_new', 'bloom_new')
        setShaderFloat('bloom_new', 'size', 10) setShaderFloat('bloom_new', 'brightness', 0)
        setShaderFloat('bloom_new', 'directions', 16) setShaderInt('bloom_new', 'quality', 3)
        setShaderFloat('bloom_new', 'threshold', .5)

        initLuaShader('fog')
        makeLuaSprite('fogShader') setSpriteShader('fogShader', 'fog')
        setShaderFloat('fogShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('fogShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
        setShaderFloatArray('fogShader', 'res', {screenWidth, screenHeight}) setShaderFloat('fogShader', 'time', 0)

        setShaderFloatArray('fogShader', 'FOG_COLOR', {166./255., 185./255., 189./255.}) setShaderFloatArray('fogShader', 'BG', {0.0, 0.0, 0.0})
        setShaderFloatArray('fogShader', 'ZOOM', 4.0) setShaderInt('fogShader', 'OCTAVES', 12) setShaderInt('fogShader', 'FEATHER', 100)
        setShaderFloat('fogShader', 'INTENSITY', 1)

        setShaderFloat('fogShader', 'applyY', 770)
        setShaderFloat('fogShader', 'applyRange', 1100)

        initLuaShader('chromaticWarp')
        makeLuaSprite('chromWarp') setSpriteShader('chromWarp', 'chromaticWarp')
        setShaderFloat('chromWarp', 'distortion', 0)
        addShader('camGame', 'chromWarp')

        initLuaShader('waterDistortion')
        makeLuaSprite('water') setSpriteShader('water', 'waterDistortion')
        setShaderFloat('water', 'strength', .0)
        addShader('camGame', 'water')

        initLuaShader('impact_frames')
        makeLuaSprite('impact') setSpriteShader('impact', 'impact_frames')
        setShaderFloat('impact', 'threshold', -1)

        initLuaShader('glitching2')
        makeLuaSprite('glitching') setSpriteShader('glitching', 'glitching2')
        setShaderFloat('glitching', 'time', 0) setShaderFloat('glitching', 'glitchAmount', 0)

        addShader('camCharacters', 'impact')
        addShader('camCharacters', 'glitching')
        addShader('camCharacters', 'bloom_new')
        addShader('camCharacters', 'saturation')
        addShader('camCharacters', 'bloom')
        addShader('camCharacters', 'fogShader')
    end
end

function onCreatePost()
    runHaxeCode([[
        for (char in [boyfriend, dad, gf])
            char.camera = getVar('camCharacters');
    ]])

    if shadersEnabled then
        addShader('camHUD', 'water')
        setShaderFloat('screenVignette', 'transparency', true)
    end
end

local __timer = 0
function onUpdate(elapsed)
    __timer = __timer + elapsed
    if shadersEnabled then
        setShaderFloat('fogShader', 'time', __timer)
        setShaderFloat('water', 'time', __timer)
        setShaderFloat('glitching', 'time', __timer)

        setShaderFloat('fogShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('fogShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
    end

    setProperty('camCharacters.scroll.x', getProperty('camGame.scroll.x'))
    setProperty('camCharacters.scroll.y', getProperty('camGame.scroll.y'))
    setProperty('camCharacters.zoom', getProperty('camGame.zoom'))
    setProperty('camCharacters.angle', getProperty('camGame.angle'))
end