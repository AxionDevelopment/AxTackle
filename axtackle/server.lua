local busyPlayers = {}

AddEventHandler('playerDropped', function()
    busyPlayers[source] = nil
end)

RegisterCommand('cleartackle', function(source)
    if source > 0 then busyPlayers[source] = nil end
end, false)

lib.callback.register('player:tryTackling', function(source, targetPlayerId)
    if busyPlayers[source] or busyPlayers[targetPlayerId] then return false end

    local tacklerPed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(targetPlayerId)
    
    if not DoesEntityExist(targetPed) or GetEntityHealth(targetPed) <= 0 then
        return false 
    end

    if #(GetEntityCoords(tacklerPed) - GetEntityCoords(targetPed)) > AxTackleConfig.MaximumDistance then
        return false 
    end

    busyPlayers[source] = true
    busyPlayers[targetPlayerId] = true

    local resisted = lib.callback.await('player:resistTackle', targetPlayerId, source, 10000)

    if resisted == nil or resisted == true then
        busyPlayers[source] = nil
        busyPlayers[targetPlayerId] = nil
        return false
    end

    SetTimeout(5000, function()
        busyPlayers[source] = nil
        busyPlayers[targetPlayerId] = nil
    end)

    return true
end)