local path = 'stages/ruins_exit/'

luaDebugMode = true

-- chromWarp, water
function onCreate()
    makeLuaSprite('BG1', path..'forest/background_back', -60)
    setScrollFactor('BG1', .7, 1)
    setProperty('BG1.antialiasing', true)
    addLuaSprite('BG1')

    makeLuaSprite('BG2', path..'forest/background_front', -40)
    setScrollFactor('BG2', .9, 1)
    setProperty('BG2.antialiasing', true)
    addLuaSprite('BG2')

    makeLuaSprite('BG3', path..'forest/middleground')
    setProperty('BG3.antialiasing', true)
    addLuaSprite('BG3')

    makeLuaSprite('PILLARS', path..'pixel/pillars')
    scaleObject('PILLARS', 7, 7, false)
    setProperty('PILLARS.antialiasing', false)
    setProperty('PILLARS.visible', false)
    addLuaSprite('PILLARS')

    makeAnimatedLuaSprite('BLASTER', path..'mechanics/gasterblaster', 720, 920)
    scaleObject('BLASTER', 1.2, 1.2, false)
    addAnimationByPrefix('BLASTER', 'blast', 'blaster_blast', 24, false)
    addAnimationByPrefix('BLASTER', 'idle', 'blaster_idle', 24, true)
    addOffset('BLASTER', 'blast', 900, 0)
    setProperty('BLASTER.antialiasing', true)
    setProperty('BLASTER.alpha', 0.000001)
    addLuaSprite('BLASTER')

    makeAnimatedLuaSprite('PRESS_SPACE', path..'mechanics/space_press', 1400, 920)
    setScrollFactor('PRESS_SPACE', 0.95, 0.9)
    addAnimationByPrefix('PRESS_SPACE', 'idle', 'space', 24, true)
    setProperty('PRESS_SPACE.antialiasing', true)
    setProperty('PRESS_SPACE.alpha', 0.000001)
    addLuaSprite('PRESS_SPACE')

    makeLuaSprite('BLASTER_IMPACT1', path..'mechanics/blasterimapct1', 430, 510)
    setProperty('BLASTER_IMPACT1.antialiasing', true)
    setProperty('BLASTER_IMPACT1.alpha', 0.000001)
    addLuaSprite('BLASTER_IMPACT1')

    makeLuaSprite('BLASTER_IMPACT2', path..'mechanics/blasterimapct2', 425, 510)
    scaleObject('BLASTER_IMPACT2', 0.9, 0.9, false)
    setProperty('BLASTER_IMPACT2.antialiasing', true)
    setProperty('BLASTER_IMPACT2.alpha', 0.000001)
    addLuaSprite('BLASTER_IMPACT2')

    makeLuaSprite('BG4', path..'forest/foreground', 15, -104)
    scaleObject('BG4', 0.82, 0.82, false)
    setScrollFactor('BG4', .8, .8)
    setProperty('BG4.antialiasing', true)
    addLuaSprite('BG4')

    if shadersEnabled then
        runHaxeCode("camGame.filters = []; camHUD.filters = [];") -- for some reason wasn't workin' with setProperty

        initLuaShader('bloom_new')
        makeLuaSprite('bloom_new') setSpriteShader('bloom_new', 'bloom_new')
        setShaderFloat('bloom_new', 'size', 10) setShaderFloat('bloom_new', 'brightness', 1.4)
        setShaderFloat('bloom_new', 'directions', 16) setShaderInt('bloom_new', 'quality', 3)
        setShaderFloat('bloom_new', 'threshold', .5)

        initLuaShader('fog')
        makeLuaSprite('fogShader') setSpriteShader('fogShader', 'fog')
        setShaderFloat('fogShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('fogShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
        setShaderFloatArray('fogShader', 'res', {screenWidth, screenHeight}) setShaderFloat('fogShader', 'time', 0)

        setShaderFloatArray('fogShader', 'FOG_COLOR', {166./255., 185./255., 189./255.}) setShaderFloatArray('fogShader', 'BG', {0.0, 0.0, 0.0})
        setShaderFloatArray('fogShader', 'ZOOM', 3.0) setShaderInt('fogShader', 'OCTAVES', 4) setShaderInt('fogShader', 'FEATHER', 100)
        setShaderFloat('fogShader', 'intensity', 1)

        setShaderFloat('fogShader', 'applyY', 1520)
        setShaderFloat('fogShader', 'applyRange', 900)

        initLuaShader('gradient')
        makeLuaSprite('gradientShader') setSpriteShader('gradientShader', 'gradient')
        setShaderFloat('gradientShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('gradientShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
        setShaderFloatArray('gradientShader', 'res', {screenWidth, screenHeight})

        setShaderFloat('gradientShader', 'applyY', 1520)
        setShaderFloat('gradientShader', 'applyRange', 1000)
    end

    createInstance('camCharacters', 'flixel.FlxCamera', {0, 0})
    createInstance('camForeground', 'flixel.FlxCamera', {0, 0})

    for x, cam in pairs({'camGame', 'camHUD', 'camOther'}) do callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cam), false}) end
    for x, cam in pairs({'camGame', 'camCharacters', 'camForeground', 'camHUD', 'camOther'}) do
        setProperty(cam..'.bgColor', 0x000000)
        callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cam), cam == 'camGame'})
    end
    runHaxeCode("getVar('camCharacters').filters = []; getVar('camForeground').filters = [];")

    if shadersEnabled then
        initLuaShader('coloredVignette')
        makeLuaSprite('screenVignette2') setSpriteShader('screenVignette2', 'coloredVignette')
        setShaderFloat('screenVignette2', 'strength', 1.0) setShaderBool('screenVignette2', 'transparency', true)
        setShaderFloat('screenVignette2', 'amount', 1)
        setShaderFloatArray('screenVignette2', 'color', {0.0, 0.0, 0.0})

        initLuaShader('chromaticWarp')
        makeLuaSprite('chromWarp') setSpriteShader('chromWarp', 'chromaticWarp')
        setShaderFloat('chromWarp', 'distortion', .3)
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
        addShader('camCharacters', 'screenVignette2')
        addShader('camCharacters', 'bloom_new')
        addShader('camCharacters', 'gradientShader')
        addShader('camCharacters', 'fogShader')

        runHaxeCode("game.getLuaObject('BG4').camera = getVar('camForeground');")
        setProperty('BG4.color', 0x1B1B1B)
    end

    makeLuaSprite('blackOverlay', nil, -2000, -500)
    makeGraphic('blackOverlay', 4000, 1500, '1b1b1b')
    setScrollFactor('blackOverlay', 0, 0)
    addLuaSprite('blackOverlay')
end

function onCreatePost()
    if shadersEnabled then
        addShader('camHUD', 'water')
    end

    runHaxeCode([[
        for (char in [boyfriend, dad, gf])
            char.camera = getVar('camCharacters');
    ]])
end

local __timer = 0
local gfAlpha = 0
function onUpdate(elapsed)
    __timer = __timer + elapsed
    if shadersEnabled then
        --if not getVar('cancelCamMove') then
            setShaderFloat('fogShader', 'time', __timer)
            setShaderFloat('water', 'time', __timer)
            setShaderFloat('glitching', 'time', __timer)
        --end

        setShaderFloat('fogShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('fogShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})

        setShaderFloat('gradientShader', 'cameraZoom', getProperty('camGame.zoom'))
        setShaderFloatArray('gradientShader', 'cameraPosition', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
    end

    setProperty('gf.x', 1397 + math.sin(__timer)*24)
    setProperty('gf.y', 850 + (math.sin(__timer*2)/2)*(12))

    setProperty('gf.alpha', (0.7 + math.sin(__timer)*.04)*gfAlpha)

    for x, cam in pairs({'camCharacters', 'camForeground'}) do
        setProperty(cam..'.scroll.x', getProperty('camGame.scroll.x'))
        setProperty(cam..'.scroll.y', getProperty('camGame.scroll.y'))
        setProperty(cam..'.zoom', getProperty('camGame.zoom'))
        setProperty(cam..'.angle', getProperty('camGame.angle'))
    end
end

function addShader(cam, shaderN)
    createInstance(shaderN..'Filter'..cam, 'openfl.filters.ShaderFilter', {instanceArg(shaderN..'.shader')})
    callMethod(cam..'.filters.push', {instanceArg(shaderN..'Filter'..cam)})
end