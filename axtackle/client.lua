local GettingTackled = false
local TACKLE_ANIM_DICT <const> = 'missmic2ig_11'
local onCooldown = false
local msgTimer = false

local cache = {
    ped = PlayerPedId(),
}

CreateThread(function()
    while true do
        cache.ped = PlayerPedId()
        Wait(1000)
    end
end)

function IsPlayingRestrictedEmote()
    local playerPed = cache.ped
    for _, emote in ipairs(AxTackleConfig.RestrictedEmotes) do
        if IsEntityPlayingAnim(playerPed, emote.dict, emote.anim, 3) then
            return true
        end
    end
    return false
end

CreateThread(function()
    local Tackling = false

    while true do
        -- Ensure states are clean if we die
        if IsEntityDead(cache.ped) then
            GettingTackled = false
            Tackling = false
        end

        -- SHIFT + E
        if IsControlPressed(1, 21) and IsControlPressed(1, 38) and not Tackling and not GettingTackled and not IsPlayingRestrictedEmote() then
            if onCooldown then
                if not msgTimer then
                    if AxTackleConfig.NotificationType == 'axionnotification' and GetResourceState('AxionNotifications') == 'started' then
                        exports['AxionNotifications']:Notify('Tackle cooldown is active.', 'error', 5000)
                    else
                        TriggerEvent('chat:addMessage', {
                            color = {255, 0, 0},
                            args = {'AxTackle', 'Tackle cooldown is active.'}
                        })
                    end
                    msgTimer = true
                    SetTimeout(5000, function() msgTimer = false end)
                end
            else
                local closestTargetId, closestTargetPed = lib.getClosestPlayer(GetEntityCoords(cache.ped), AxTackleConfig.MaximumDistance, false)
                
                if closestTargetId and not IsPedInAnyVehicle(closestTargetPed) and GetEntityHealth(closestTargetPed) > 0 then
                    Tackling = true

                    local canTackle = lib.callback.await('player:tryTackling', 10000, GetPlayerServerId(closestTargetId))

                    if canTackle then
                        lib.requestAnimDict(TACKLE_ANIM_DICT)
                        TaskPlayAnim(cache.ped, TACKLE_ANIM_DICT, 'mic_2_ig_11_intro_goon', 8.0, -8.0, 3000, 0, 0, false, false, false)
                        
                        onCooldown = true
                        SetTimeout(AxTackleConfig.Cooldown * 1000, function()
                            onCooldown = false
                        end)

                        Wait(3000)
                    end

                    Tackling = false
                end
            end
            Wait(250)
        end
        Wait(0)
    end
end)

lib.callback.register('player:resistTackle', function(tacklerId)
    if not tacklerId or GettingTackled or IsEntityDead(cache.ped) or IsPedInAnyVehicle(cache.ped) then 
        return true 
    end

    local canResist = false
    if AxTackleConfig.Resistable then
        canResist = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'}, AxTackleConfig.ResistKeys)
    end

    if not canResist then
        CreateThread(function()
            GettingTackled = true
            local targetPed = GetPlayerPed(GetPlayerFromServerId(tacklerId))

            if AxTackleConfig.DisarmOnTackle then
                SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            end

            lib.requestAnimDict(TACKLE_ANIM_DICT)
            
            SetEntityNoCollisionEntity(cache.ped, targetPed, true)

            AttachEntityToEntity(cache.ped, targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
            TaskPlayAnim(cache.ped, TACKLE_ANIM_DICT, 'mic_2_ig_11_intro_p_one', 8.0, -8.0, 3000, 0, 0, false, false, false)

            Wait(3000)
            
            DetachEntity(cache.ped, true, false)
            
            if not IsEntityDead(cache.ped) then
                SetPedToRagdoll(cache.ped, 1500, 1500, 0, false, false, false)
            end
            
            Wait(1000)
            GettingTackled = false
        end)
    end

    return canResist
end)