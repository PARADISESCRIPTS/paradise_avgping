local pingData = {}
Citizen.CreateThread(function()
    while true do
        local players = GetPlayers()
        local totalPing = 0
        local playerCount = #players
        -- Calculate average ping
        for _, playerId in ipairs(players) do
            local ping = GetPlayerPing(playerId)
            totalPing = totalPing + ping
        end
        -- Store the average ping
        pingData.average = playerCount > 0 and math.floor(totalPing / playerCount) or 0
        -- Wait 30 seconds before next update
        Citizen.Wait(30000)
    end
end)

-- Add average ping to server info
AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    SetConvarServerInfo('Average Ping', '0ms')
    Citizen.CreateThread(function()
        while true do
            SetConvarServerInfo('Average Ping', pingData.average .. 'ms')
            Citizen.Wait(30000)
        end
    end)
end)