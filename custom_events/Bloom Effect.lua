if not shadersEnabled then return end

addHaxeLibrary('LuaUtils', 'psychlua')

function onCreate()
    initLuaShader('bloom')

    makeLuaSprite('bloom') setSpriteShader('bloom', 'bloom')
    setShaderFloat('bloom', 'size', 0) setShaderFloat('bloom', 'brightness', 1)
    setShaderFloat('bloom', 'directions', 8) setShaderInt('bloom', 'quality', 4)
    addShader('camGame', 'bloom')
    addShader('camHUD', 'bloom')
end

setVar('curbloom', 1)

function onEvent(name, value1, value2)
    local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')
    if name == "Bloom Effect" then
        if params1[1] == 'false' then
            setBloom(params1[2])
        else
            local flxease = params2[1]..(params2[1] == 'linear' and '' or params2[2])
            runHaxeCode([[
                if (getVar('bloomTween') != null) getVar('bloomTween').cancel();
                setVar('bloomTween', FlxTween.num(getVar('curbloom'), ]]..params1[2]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params1[3]..[[, 
                {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {parentLua.call('setBloom', [val]);}));
            ]])
        end
    end
end

function setBloom(bloom_effect)
    setShaderFloat('bloom', 'size', math.max((bloom_effect) - 1, 0) * 4.5)
    setShaderFloat('bloom', 'brightness', math.max(bloom_effect, 1))

    setVar('curbloom', bloom_effect)
end