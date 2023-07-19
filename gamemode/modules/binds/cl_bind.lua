DarkRP.Buttons = DarkRP.Buttons or {}
DarkRP.Buttons.List = DarkRP.Buttons.List or {}

function DarkRP.Buttons.Register(keyNum, uniqueName, options)
    assert(type(keyNum) == "number", "DarkRP.Buttons.Register: keyNum n'est pas un nombre !")
    assert(type(uniqueName) == "string", "DarkRP.Buttons.Register: uniqueName n'est pas une chaîne de caractères !")
    assert(type(options) == "table", "DarkRP.Buttons.Register: options n'est pas une table !")
    assert(type(options.callback) == "function", "DarkRP.Buttons.Register: options.callback n'est pas une fonction !")

    options.cooldown = options.cooldown or 0.5

    DarkRP.Buttons.List[keyNum] = DarkRP.Buttons.List[keyNum] or {}
    DarkRP.Buttons.List[keyNum][uniqueName] = options

    if options.bind then
        DarkRP.Buttons.List[options.bind] = DarkRP.Buttons.List[options.bind] or {}
        DarkRP.Buttons.List[options.bind][uniqueName] = options
    end

    return true
end

function DarkRP.Buttons.Delete(keyNum, uniqueName)
    assert(type(keyNum) == "number", "DarkRP.Buttons.Delete: keyNum n'est pas un nombre !")
    assert(type(uniqueName) == "string", "DarkRP.Buttons.Delete: uniqueName n'est pas une chaîne de caractères !")

    local buttons = DarkRP.Buttons.List[keyNum]
    if buttons then
        buttons[uniqueName] = nil
    end

    return true
end

hook.Add("PlayerButtonDown", "DarkRP:Buttons:Detection", function(ply, key)
    if ply ~= LocalPlayer() or type(key) ~= "number" then
        return
    end

    local buttons = DarkRP.Buttons.List[key]
    if buttons then
        for uniqueName, options in pairs(buttons) do
            if type(options.bind) == "string" and not input.LookupBinding(options.bind) and (not options.lastCall or options.lastCall < CurTime()) then
                options.callback()
                options.lastCall = CurTime() + options.cooldown
            end
        end
    end
end)

hook.Add("PlayerBindPress", "DarkRP:Buttons:BindDetection", function(ply, bind, pressed)
    if ply ~= LocalPlayer() or type(bind) ~= "string" or not pressed then
        return
    end

    local buttons = DarkRP.Buttons.List[bind]
    if buttons then
        for uniqueName, options in pairs(buttons) do
            if not options.lastCall or options.lastCall < CurTime() then
                options.callback()
                options.lastCall = CurTime() + options.cooldown
            end
        end
    end
end)
