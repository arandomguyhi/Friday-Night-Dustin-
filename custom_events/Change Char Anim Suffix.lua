function onEvent(name, value1, value2)
    if name == 'Change Char Anim Suffix' then
        local char = tostring(value1)
        if char == '0' then char = 'dad' end
        if char == '1' then char = 'boyfriend' end
        if char == '2' then char = 'gf' end

        setProperty(char..'.idleSuffix', tostring(value2))

        for i = 0, getProperty('notes.length')-1 do
            if getProperty('notes.members['..i..'].mustPress') == (char == 'boyfriend') or char == 'gf' and getProperty('notes.members['..i..'].gfNote') then
                setProperty('notes.members['..i..'].animSuffix', tostring(value2))
            end
        end
        for i = 0, getProperty('unspawnNotes.length')-1 do
            if getProperty('unspawnNotes['..i..'].mustPress') == (char == 'boyfriend') or char == 'gf' and getProperty('unspawnNotes['..i..'].gfNote') then
                setProperty('unspawnNotes['..i..'].animSuffix', tostring(value2))
            end
        end
    end
end