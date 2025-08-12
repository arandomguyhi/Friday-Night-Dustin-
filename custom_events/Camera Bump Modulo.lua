function onEvent(name, value1, value2)
    if name == 'Camera Bump Modulo' then
        setVar('camZoomingInterval', value1)
        setVar('camZoomingStrength', value2)
    end
end