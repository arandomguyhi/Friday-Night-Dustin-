if not shadersEnabled then return end

addHaxeLibrary('LuaUtils', 'psychlua')

function onCreate()
    initLuaShader('saturation')

    makeLuaSprite('saturation') setSpriteShader('saturation', 'saturation')
    setShaderFloat('saturation', 'sat', 1)
    setShaderFloat('saturation', 'contrast', 1)
    addShader('camGame', 'saturation')
    addShader('camHUD', 'saturation')
end

setVar('curSaturation', 1)

function onEvent(name, value1, value2)
    local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')
    if name == "Saturation Effect" then
         debugPrint('oi')
        if params1[1] == 'false' then
            setShaderFloat('saturation', 'sat', params1[2]) setVar('curSaturation', params1[2])
        else
            local flxease = params2[1]..(params2[1] == 'linear' and '' or params2[2])
            runHaxeCode([[
                if (getVar('saturationTween') != null) getVar('saturationTween').cancel();
                setVar('saturationTween', FlxTween.num(getVar('curSaturation'), ]]..params1[2]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params1[3]..[[, 
                {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {
                    parentLua.call('setShaderFloat', ['saturation', 'sat', val]);
                    setVar('curSaturation', val);
                }));
            ]])
        end
    end
end