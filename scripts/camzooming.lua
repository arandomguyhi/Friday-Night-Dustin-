luaDebugMode = true

setVar('strumLineDadZoom', 0)
setVar('strumLineBfZoom', 0)
setVar('strumLineGfZoom', 0)
local camZoomMult = 1
local camZoomLerpMult = 1

setVar('lerpCamZoom', true)
local forceDefaultCamZoom = false

local function lerp(a,b,t) return a + (b - a) * t end

local stage = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('stages/'..curStage..'.json')})
function onCreate()
    setProperty('camZooming', false)

    if stage == nil then return end
    setVar('strumLineDadZoom', stage.opponentZoom and stage.opponentZoom or -1)
    setVar('strumLineBfZoom', stage.playerZoom and stage.playerZoom or -1)
    setVar('strumLineGfZoom', stage.gfZoom and stage.gfZoom or -1)
end

function onUpdate(elapsed)
    setProperty('camZooming', false)
    if getVar('lerpCamZoom') then
        local stageZoom = forceDefaultCamZoom and getProperty('defaultCamZoom') or ((not gfSection and (mustHitSection and getVar('strumLineBfZoom') or getVar('strumLineDadZoom')) or getVar('strumLineGfZoom')))
        setProperty('camGame.zoom', lerp(getProperty('camGame.zoom'), stageZoom == -1 and getProperty('defaultCamZoom') or stageZoom, 0.05 * camZoomLerpMult))
        setProperty('camHUD.zoom', lerp(getProperty('camHUD.zoom'), 1 * camZoomMult, 0.05))
    end
end