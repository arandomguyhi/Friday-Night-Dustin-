luaDebugMode = true

addHaxeLibrary('FlxFlicker', 'flixel.effects')

function onCreatePost()
    if shadersEnabled then
        initLuaShader('blackwhite')
        makeLuaSprite('blackwhite') setSpriteShader('blackwhite', 'blackwhite')
        setShaderFloat('blackwhite', 'grayness', 1)
        for x, cam in pairs({'camGame', 'camHUD', 'camCharacters', 'camForeground'}) do
            addShader(cam, 'blackwhite')
        end

        initLuaShader('static')
        makeLuaSprite('oldstatic') setSpriteShader('oldstatic', 'static')
        setShaderFloat('oldstatic', 'time', 0) setShaderFloat('oldstatic', 'strength', 1.2)
        for x, cam in pairs({'camGame', 'camHUD', 'camCharacters', 'camForeground'}) do
            addShader(cam, 'oldstatic')
        end

        initLuaShader('pixel')
        makeLuaSprite('pixel') setSpriteShader('pixel', 'pixel')
        setShaderFloat('pixel', 'blockSize', 1.0)
        setShaderFloatArray('pixel', 'res', {screenWidth, screenHeight})
    end

    if shadersEnabled then
        initLuaShader('iconshader')
        for x, char in pairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(char, 'iconshader')
            setShaderFloat(char, 'minBrightness', .01)
            setShaderFloatArray(char, 'color', {.01, .01, .01})
            setShaderFloat(char, 'ratio', 1)
        end
    end

    makeLuaSprite('blackOverlayHUD')
    makeGraphic('blackOverlayHUD', screenWidth, screenHeight, '000000')
    setScrollFactor('blackOverlayHUD', 0, 0)
    setObjectCamera('blackOverlayHUD', 'camHUD')
    addLuaSprite('blackOverlayHUD')
end

function onSongStart()
    startTween('blackTween', 'blackOverlayHUD', {alpha = 0}, 7, {}) time = 0
end

local time = 0
function onUpdate(elapsed)
    time = time + elapsed
    if luaSpriteExists('oldstatic') then setShaderFloat('oldstatic', 'time', time)end
end

function onStepHit()
    if curStep == 96 then
        doTweenColor('blackOT', 'blackOverlay', '5F5F5F', (stepCrochet/1000) * 32, 'quadInOut')
    end

    if curStep == 128 then
        startTween('blackBye', 'blackOverlay', {alpha = 0}, 3.6, {})

        runHaxeCode([[
            for (char in ['boyfriend', 'dad', 'gf'])
                FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.quadInOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', [char, 'ratio', val]);
                });
        ]])
        setProperty('camGame.followLerp', 0.02)
    end
end

function addShader(cam, shaderN)
    createInstance(shaderN..'Filter'..cam, 'openfl.filters.ShaderFilter', {instanceArg(shaderN..'.shader')})
    callMethod(cam..'.filters.push', {instanceArg(shaderN..'Filter'..cam)})
end