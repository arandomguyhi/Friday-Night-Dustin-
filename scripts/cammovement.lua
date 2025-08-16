setProperty('isCameraOnForcedPos', true)

setVar('camMoveOffset', 15)
setVar('camAngleOffset', .3)

setVar('camFollowChars', true)
setVar('camAngleChars', true)

local movement = {}
local angle = 0

local function lerp(a,b,t) return a + (b - a) * t end
local function getCamPos(char)
    local _char = char

    if char == 'gf' then _char = 'girlfriend' end
    if char == 'dad' then _char = 'opponent' end

    local bro = getProperty(char..'.cameraPosition[0]')
    return {
        x = (getMidpointX(char) + (char == 'boyfriend' and -100 or (char == 'dad' and 150 or 0))) + getProperty(char..'.cameraPosition[0]') + getProperty(_char..'CameraOffset[0]'),
        y = (getMidpointY(char) - ((char == 'boyfriend' or char == 'dad') and 100 or 0)) + getProperty(char..'.cameraPosition[1]') + getProperty(_char..'CameraOffset[1]')
    }
end

local speedizer = 0
local xoffset = 0
local yoffset = 0
local angleoffset = 0
function shake(traumatizerr, speedizzerr)
    traumatizerr, speedizzerr = 0.3, 0.02
    t = traumatizerr
    speedizer = speedizzerr
    xoffset = getRandomFloat(-100, 100)
    yoffset = getRandomFloat(-100, 100)
    angleoffset = getRandomFloat(-100, 100)
end

local t = 0
local peakAngle = 0
function updateShake(elapsed)
    t = callMethodFromClass('flixel.math.FlxMath', 'bound', {t - (speedizer * elapsed), 0, 1})
    --setProperty('camGame.angle', getProperty('camGame.angle') + 1.5 * (t * t) * callMethodFromClass('flixel.addons.util.FlxSimplex', 'simplex', {t * 25.5, t * 25.5 + angleoffset}))
    --setProperty('camGame.scroll.x', getProperty('camGame.scroll.x') + 50 * (t * t) * callMethodFromClass('flixel.addons.util.FlxSimplex', 'simplex', {t * 100 + xoffset, 10}))
    --setProperty('camGame.scroll.y', getProperty('camGame.scroll.y') + 50 * (t * t) * callMethodFromClass('flixel.addons.util.FlxSimplex', 'simplex', {10, t * 100 + yoffset}))

    if peakAngle < math.abs(getProperty('camGame.angle')) then
        peakAngle = math.abs(getProperty('camGame.angle')) end
end

local baseAngle = 0
local lastBaseAngle = 0

function onSectionHit() setVar('lastFocus', (not gfSection and (mustHitSection and 'boyfriend' or 'dad') or 'gf')) end
function onUpdate(elapsed)
    if getVar('camFollowChars') then
        if getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singLEFT' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x - getVar('camMoveOffset'), getCamPos(getVar('lastFocus')).y}) angle = -getVar('camAngleOffset')
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singDOWN' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y + getVar('camMoveOffset')})
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singUP' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y - getVar('camMoveOffset')})
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singRIGHT' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x + getVar('camMoveOffset'), getCamPos(getVar('lastFocus')).y}) angle = getVar('camAngleOffset')
        else
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y}) angle = 0
        end
    end

    if getVar('camAngleChars') then
        setProperty('camGame.angle', lerp(getProperty('camGame.angle') - lastBaseAngle, angle, 1/10))
        setProperty('camGame.angle', getProperty('camGame.angle') + lastBaseAngle) lastBaseAngle = baseAngle
    end
    updateShake(elapsed)
end