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

        if shadersEnabled then
            runHaxeCode([[
                for (char in ['boyfriend', 'dad', 'gf'])
                    FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.quadInOut}, (val:Float) -> {
                        game.callOnLuas('setShaderFloat', [char, 'ratio', val]);
                    });
            ]])
        end
        setProperty('camGame.followLerp', 0.02)
    end

    if curStep == 544 then
        cameraShake('camGame', 0.000001, 999999)
        runHaxeCode("FlxTween.tween(game.camGame, {_fxShakeIntensity: 0.0009}, (Conductor.stepCrochet / 1000) * 100);")
    end

    if curStep == 645 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(1.3, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['oldstatic', 'strength', val]);
                });
                FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['blackwhite', 'grayness', val]);
                });

                FlxTween.num(1.4, 1, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]); });
                FlxTween.num(10, 25, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['bloom_new', 'size', val]); });

                FlxTween.num(5, .7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['chromWarp', 'distortion', val]);
                });
            ]])
        end
        callMethod('camGame.stopFX', {''})
        cameraFlash('camGame', '19A2F2', (stepCrochet / 1000) * 4)
    end

    if curStep == 656 then
        if shadersEnabled then
            setShaderBool('screenVignette', 'transparency', true)

            removeShader('camGame', 'screenVignette')
            addShader('camForeground', 'screenVignette')

            removeShader('camCharacters', 'screenVignette')
            addShader('camCharacters', 'bloom')

            runHaxeCode([[
                FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]); });
                FlxTween.num(.7, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['chromWarp', 'distortion', val]); });
            ]])
        end
        setProperty('camGame.followLerp', 0.035)
    end

    if curStep == 752 or curStep == 760 or curStep == 768 or curStep == 880 or curStep == 888 or curStep == 896 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['water', 'strength', val]); });
                FlxTween.num(.4, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['chromWarp', 'distortion', val]); });
                FlxTween.num(1.3, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]); });
                FlxTween.num(35, 10, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                    game.callOnLuas('setShaderFloat', ['bloom_new', 'size', val]); });
            ]])
        end
    end
end

function addShader(cam, shaderN)
    createInstance(shaderN..'Filter'..cam, 'openfl.filters.ShaderFilter', {instanceArg(shaderN..'.shader')})
    callMethod(cam..'.filters.push', {instanceArg(shaderN..'Filter'..cam)})
end

function removeShader(cam, shaderN)
    callMethod(cam..'.filters.remove', {callMethod(cam..'.filters.indexOf', {instanceArg(shaderN..'Filter'..cam)})})
end