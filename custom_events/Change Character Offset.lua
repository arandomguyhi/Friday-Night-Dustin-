-- this is horrible help 😭

local changingValue = false

for i, char in pairs({'opponent', 'boyfriend', 'girlfriend'}) do
    makeLuaSprite('camHelper'..char)
    setProperty('camHelper'..char..'.x', getProperty(char..'CameraOffset[0]'))
    setProperty('camHelper'..char..'.y', getProperty(char..'CameraOffset[1]'))
    setVar('og'..char..'X', getProperty('camHelper'..char..'.x')) setVar('og'..char..'Y', getProperty('camHelper'..char..'.y'))
end

function onEvent(name, value1, value2)
    if name == 'Change Character Offset' then
        local params1, params2 = stringSplit(value1, ','), stringSplit(value2, ',')
        local flxease = params2[2]..(params2[2] == 'linear' and '' or params2[3])

        local char = params1[2]
        if char == '0' then char = 'opponent' end
        if char == '1' then char = 'boyfriend' end
        if char == '2' then char = 'girlfriend' end

        if params1[1] then
            changingValue = true

            runTimer('changingTimer'..params1[2], ((crochet/4)/1000) * params2[1])
            startTween('characterTweenX'..char, 'camHelper'..char, {x = getVar('og'..char..'X') + params1[3]}, ((crochet/4)/1000) * params2[1], {ease = flxease})
            startTween('characterTweenY'..char, 'camHelper'..char, {y = getVar('og'..char..'Y') + params1[4]}, ((crochet/4)/1000) * params2[1], {ease = flxease})
        else
            setProperty(char..'CameraOffset[0]', getProperty(char..'CameraOffset[0]') + params[3])
            setProperty(char..'CameraOffset[1]', getProperty(char..'CameraOffset[1]') + params[4])
        end
    end
end

function onTimerCompleted(tag)
    for i = 0, 2 do
        if tag == 'changingTimer'..i then
            changingValue = false
        end
    end
end

function onUpdate()
    if changingValue then
        setProperty('opponentCameraOffset[0]', getProperty('camHelperopponent.x'))
        setProperty('opponentCameraOffset[1]', getProperty('camHelperopponent.y'))

        setProperty('boyfriendCameraOffset[0]', getProperty('camHelperboyfriend.x'))
        setProperty('boyfriendCameraOffset[1]', getProperty('camHelperboyfriend.y'))
    end
end