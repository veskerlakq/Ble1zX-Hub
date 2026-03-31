local kill = {}
function kill.logic()
    spawn(function()
        while task.wait(0.2) do
            if _G.AutoKill then
                -- Логика проверки Targets и телепорта над мобами
                -- ...
            end
        end
    end)
end
return kill
