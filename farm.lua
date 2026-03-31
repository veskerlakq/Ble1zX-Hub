local farm = {}
function farm.start()
    spawn(function()
        while true do
            task.wait(0.5)
            if _G.Farm then
                local target = _G.Fields[_G.SelectedField]
                -- Полет и копка (код из прошлых версий)
                -- ... (логика TweenService и CollectPollen)
            end
        end
    end)
end
return farm
