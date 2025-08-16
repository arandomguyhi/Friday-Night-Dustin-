if not shadersEnabled then return end

addHaxeLibrary('LuaUtils', 'psychlua')

luaDebugMode = true

setVar('curStrength', 0.1)
setVar('curAmount', 0.1)

function onCreate()
    initLuaShader('coloredVignette')

    makeLuaSprite('screenVignette') setSpriteShader('screenVignette', 'coloredVignette')
    setShaderFloat('screenVignette', 'strength', 0.1) setShaderFloat('screenVignette', 'quality', 4)
    setShaderFloat('screenVignette', 'amount', 0.1)
    setShaderFloatArray('screenVignette', 'color', {0.0, 0.0, 0.0})
    addShader('camGame', 'screenVignette')
end

function onEvent(name, value1, value2)
    if name == "Screen Vignette" then
        local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')

        if params1[1] == 'false' then
            setShaderFloat('screenVignette', 'amount', params1[2]) setVar('curAmount', params1[2])
            setShaderFloat('screenVignette', 'strength', params1[3]) setVar('curStrength', params1[3])
        else
            local flxease = params2[2]..(params2[2] == 'linear' and '' or params2[3])
            runHaxeCode([[
                if (getVar('strengthTween') != null) getVar('strengthTween').cancel();
                setVar('strengthTween', FlxTween.num(getVar('curStrength'), ]]..params1[3]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params2[1]..[[, 
                {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {
                    parentLua.call('setShaderFloat', ['screenVignette', 'strength', val]);
                    setVar('curStrength', val);
                }));

                if (getVar('amountTween') != null) getVar('amountTween').cancel();
                setVar('amountTween', FlxTween.num(getVar('curAmount'), ]]..params1[2]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params2[1]..[[, 
                {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {
                    parentLua.call('setShaderFloat', ['screenVignette', 'amount', val]);
                    setVar('curAmount', val);
                }));
            ]])
        end
    end
end