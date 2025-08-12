function onEvent(name, value1, value2)
    if name == 'Camera Flash' then
        local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')

        if params1[1] then
            callMethod(params2[2]..'.fade', {params1[2], ((crochet / 4) / 1000) * params2[1], false})
        else
            callMethod(params2[2]..'.flash', {params1[2], ((crochet / 4) / 1000) * params2[1], nil, true})
        end
    end
end