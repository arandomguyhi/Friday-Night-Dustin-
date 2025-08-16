function onCreatePost()
    makeAnimatedLuaSprite('papyrusNutting', 'game/cutscenes/kinemorto/papyrusBLOWINGup')
    addAnimationByPrefix('papyrusNutting', 'burstin', 'pop off girl', 18)
    scaleObject('papyrusNutting', 0.68, 0.68, false)
    addLuaSprite('papyrusNutting')
    setScrollFactor('papyrusNutting', 0, 0)
    screenCenter('papyrusNutting')
    setProperty('papyrusNutting.alpha', 0.0001)
    setProperty('papyrusNutting.camera', instanceArg('camCharacters'), false, true)

    createInstance('fog', 'flixel.addons.display.FlxBackdrop', {})
    loadGraphic('fog', 'game/cutscenes/kinemorto/fogBG')
    scaleObject('fog', 3, 3, false)
    setProperty('fog.alpha', 0.0001)
    addInstance('fog')
    setProperty('fog.velocity.x', 80)
    setScrollFactor('fog', 0, 0)

    if shadersEnabled then
        initLuaShader('blackwhite')
        makeLuaSprite('blackwhite') setSpriteShader('blackwhite', 'blackwhite')
        setShaderFloat('blackwhite', 'grayness', 0)
        for x, cam in pairs({'camGame', 'camHUD', 'camCharacters'}) do addShader(cam, 'blackwhite') end

        initLuaShader('static')
        makeLuaSprite('oldstatic') setSpriteShader('oldstatic', 'static')
        setShaderFloat('oldstatic', 'time', 0) setShaderFloat('oldstatic', 'strength', 0)
        for x, cam in pairs({'camGame', 'camHUD', 'camCharacters'}) do addShader(cam, 'oldstatic') end

        initLuaShader('warp')
        makeLuaSprite('warp') setSpriteShader('warp', 'warp')
        setShaderFloat('warp', 'distortion', 0)
        for x, cam in pairs({'camGame', 'camCharacters'}) do addShader(cam, 'warp') end

        initLuaShader('radial')
        makeLuaSprite('radial') setSpriteShader('radial', 'radial')
        setShaderFloat('radial', 'blur', 0) setShaderFloatArray('radial', 'center', {0.5, 0.5})
        addShader('camGame', 'radial')
    end
end

local shaketime = 0
local time = 0
function onUpdate(elapsed)
    if shaketime > 0 then
        local xMod = getRandomFloat(-1, 1)*1.5
        local yMod = getRandomFloat(-1, 1)*1.5

        for x, cam in pairs({'camGame', 'camCharacters', 'camHUD'}) do
            setProperty(cam..'.scroll.x', xMod) setProperty(cam..'.scroll.y', yMod)
        end
        shaketime = shaketime - elapsed
    end

    time = time + elapsed
    if shadersEnabled then
        setShaderFloat('oldstatic', 'time', time)
    end
    if getProperty('papyrusNutting.alpha') < 1 then return end

    screenCenter('papyrusNutting')
    setProperty('papyursNutting.x', getProperty('papyrusNutting.x') + getRandomFloat(-10, 10))
    setProperty('papyursNutting.y', getProperty('papyrusNutting.y') + getRandomFloat(-10, 10))

    if getProperty('dad.animation.curAnim.name') == 'intro' and getProperty('dad.animation.curAnim.finished') then
        playAnim('dad', 'intro2', true)
    end
end

function onStepHit()
    if curStep == 49 then
        playAnim('dad', 'intro', true)
    elseif curStep == 736 then
        playAnim('dad', 'stoopidDeath', true)
        runHaxeCode([[
            dad.animation.finishCallback = function(animName:String) {
                if (animName == "stoopidDeath") {
                    dad.playAnim("stoopidDeath2");
                }

                if (animName == "stoopidDeath2") {
                    dad.playAnim("stoopidDeath3");
                }
            };
        ]])
    end

    if curStep == 312 or curStep == 672 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['water', 'strength', val]);});
                FlxTween.num(.2, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['chromWarp', 'distortion', val]);});
                FlxTween.num(1.3, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]);});
                FlxTween.num(35, 10, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'size', val]);});
            ]])
        end
    end

    if curStep == 384 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['water', 'strength', val]);});
                FlxTween.num(.2, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['chromWarp', 'distortion', val]);});
            ]])
        end
    end

    if curStep == 416 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(0, .001, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['radial', 'blur', val]);});
                FlxTween.num(0, .3, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['water', 'strength', val]);});
                FlxTween.num(0, .8, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['oldstatic', 'strength', val]);});
                FlxTween.num(0, .25, (Conductor.stepCrochet / 1000) * 1, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['blackwhite', 'grayness', val]);});

                 // SNOW SHADER ONES
                //FlxTween.num(1.6, .6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {setVar('snowSpeed', val);});
                //FlxTween.num(1, 2.8, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['snowShader2', 'BRIGHT', val]);});
                //FlxTween.num(1, 2.4, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['snowShader', 'BRIGHT', val]);});

                FlxTween.num(0, .44, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]);});
                FlxTween.num(10, 13, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'size', val]);});
                FlxTween.num(1, 1.7, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['fogShader', 'INTENSITY', val]);});
            ]])
        end
    end

    if curStep == 544 then
        if shadersEnabled then
            runHaxeCode([[
                FlxTween.num(.087, .001, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['radial', 'blur', val]);});
                FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['water', 'strength', val]);});
                FlxTween.num(.8, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['oldstatic', 'strength', val]);});
                FlxTween.num(.25, .15, (Conductor.stepCrochet / 1000) * 1, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['blackwhite', 'grayness', val]);});

                 // SNOW SHADER ONES
                //FlxTween.num(.6, 2.2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {setVar('snowSpeed', val);});
                //FlxTween.num(2.8, 1.6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['snowShader2', 'BRIGHT', val]);});
                //FlxTween.num(2.4, 1.6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['snowShader', 'BRIGHT', val]);});

                FlxTween.num(.44, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'brightness', val]);});
                FlxTween.num(13, 10, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['bloom_new', 'size', val]);});
                FlxTween.num(1.7, 1.6, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {game.callOnLuas('setShaderFloat', ['fogShader', 'INTENSITY', val]);});
            ]])
        end
        setVar('camZoomMult', .94)
    end

    if curStep == 726 then
        setVar('camZoomMult', 1)
    end

    if curStep == 800 then
        for x, cam in pairs(getPropertyFromClass('flixel.FlxG', 'cameras.list')) do
            setProperty(cam..'.visible', false)
        end
        runTimer('nutPap', 0.06)
        onTimerCompleted = function(tag) if tag == 'nutPap' then
           setProperty('papyrusNutting.alpha', 1)
           playAnim('papyrusNutting', 'burstin', true) end
        end
    end

    if curStep == 832 then
        if shadersEnabled then
            setShaderFloat('snowShader2', 'BRIGHT', 2) setShaderFloat('snowShader', 'BRIGHT', 2)
            setShaderFloat('fogShader', 'INTENSITY', 1.3) setVar('camZoomMult', 1)
            setShaderFloat('radial', 'blur', .019) setVar('idleSpeed', 0.2) setVar('snowSpeed', 1.5)
            setShaderFloat('oldstatic', 'strength', 2) setShaderFloat('blackwhite', 'grayness', .7)

            setShaderFloat('bloom_new', 'brightness', 1.2) setShaderFloat('water', 'strength', .2)
        end
    end
end