if not shadersEnabled then return end

addHaxeLibrary('LuaUtils', 'psychlua')

function onCreate()
    initLuaShader('saturation')

    makeLuaSprite('contrast') setSpriteShader('contrast', 'saturation')
    setShaderFloat('contrast', 'sat', 1)
    setShaderFloat('contrast', 'contrast', 1)
    addShader('camGame', 'contrast')
    addShader('camHUD', 'contrast')
end

setVar('curContrast', 1)

function onEvent(name, value1, value2)
    if name == "Contrast Effect" then
        local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')

        if params1[1] == 'false' then
            setShaderFloat('contrast', 'contrast', params1[2]) setVar('curContrast', params1[2])
        else
            local flxease = params2[1]..(params2[1] == 'linear' and '' or params2[2])
            runHaxeCode([[
                if (getVar('contrastTween') != null) getVar('contrastTween').cancel();
                setVar('contrastTween', FlxTween.num(getVar('curContrast'), ]]..params1[2]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params1[3]..[[, 
                {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {
                    parentLua.call('setShaderFloat', ['contrast', 'contrast', val]);
                    setVar('curContrast', val);
                }));
            ]])
        end
    end
end