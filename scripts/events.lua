luaDebugMode = true

runHaxeCode([[
    import psychlua.FunkinLua;

    // why i've made this? idk, and don't ask why
    var defaultZoomTween:FlxTween; setVar('defaultZoomTween', defaultZoomTween);
    var bfZoomTween:FlxTween; setVar('bfZoomTween', bfZoomTween);
    var dadZoomTween:FlxTween; setVar('dadZoomTween', dadZoomTween);
    var gfZoomTween:FlxTween; setVar('gfZoomTween', gfZoomTween);

    FunkinLua.customFunctions.set('addShader', function(cam:String, shaderName:String) {
        parentLua.call('addShader', [cam, shaderName]);
    });
]])

function onEvent(name, value1, value2)
    if name == 'Change Stage Zoom' then
        local params1 = stringSplit(value1, ',')
        local params2 = stringSplit(value2, ',')

        if params1[5] then
            local flxease = params2[3]..(params2[3] == "linear" and "" or params2[4])
            if params1[1] then debugPrint('default')
                cancelTween('defaultZoomTween')
                startTween('defaultZoomTween', 'game', {defaultCamZoom = params2[1]}, ((crochet / 4) / 1000) * params2[2], {ease = tostring(flxease)})
            end
            if params1[2] then
                runHaxeCode([[
                    if (getVar('bfZoomTween') != null) getVar('bfZoomTween').cancel();
                    setVar('bfZoomTween', FlxTween.num(getVar('strumLineBfZoom'), ]]..params2[1]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params2[2]..[[, 
                    {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {setVar('strumLineBfZoom', val);}));
                ]])
            end
            if params1[3] then
                runHaxeCode([[
                    if (getVar('dadZoomTween') != null) getVar('dadZoomTween').cancel();
                    setVar('dadZoomTween', FlxTween.num(getVar('strumLineDadZoom'), ]]..params2[1]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params2[2]..[[, 
                    {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {setVar('strumLineDadZoom', val);}));
                ]])
            end
            if params1[4] then
                runHaxeCode([[
                    if (getVar('gfZoomTween') != null) getVar('gfZoomTween').cancel();
                    setVar('gfZoomTween', FlxTween.num(getVar('strumLineGfZoom'), ]]..params2[1]..[[, ((Conductor.crochet / 4) / 1000) * ]]..params2[2]..[[, 
                    {ease: LuaUtils.getTweenEaseByString(']]..flxease..[[')}, (val:Float) -> {setVar('strumLineGfZoom', val);}));
                ]])
            end
        else
            if params1[1] then setProperty('defaultCamZoom', params2[1]) end
            if params1[2] then setVar('strumLineBfZoom', params2[1]) end
            if params1[3] then setVar('strumLineDadZoom', params2[1]) end
            if params1[4] then setVar('strumLineGfZoom', params2[1]) end
        end
    end
end

function addShader(cam, shaderN)
    createInstance(shaderN..'Filter'..cam, 'openfl.filters.ShaderFilter', {instanceArg(shaderN..'.shader')})
    callMethod(cam..'.filters.push', {instanceArg(shaderN..'Filter'..cam)})
end