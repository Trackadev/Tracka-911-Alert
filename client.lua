local expiry = 100 -- Seconds till message expires

local onCooldown = false
local cooldown = 30 -- Cool down until another alert can be sent out

local prefix = "911"

RegisterNetEvent('tracka_alert:new')
AddEventHandler('tracka_alert:new', function(name, description, cords)
    local streetHash = GetStreetNameAtCoord(cords.x, cords.y, cords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    TriggerEvent('chat:addMessage', {
        color = { 0, 204, 204},
        multiline = true,
        args = { "Emegency Scanner", "^4Caller: ^0^*".. name.." | ^4Location: ^0" .. streetName .." | ^4^*Transcript: ^0".. description }
    })

    local blip = AddBlipForCoord(cords.x, cords.y, cords.z)
    SetBlipSprite(blip, 285) --Change Value here to change the blip sprite (https://docs.fivem.net/docs/game-references/blips/)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.5)
    SetBlipColour(blip, 37)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Active Call by " .. name) -- Change Value here to change the blip description
    EndTextCommandSetBlipName(blip)
    SetTimeout(expiry * 1000, function()
        RemoveBlip(blip)
    end)
end)

RegisterCommand(prefix, function(source, args, rawCommand)
    
    if onCooldown then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = { "Emegency Scanner", "^1You must wait " .. cooldown .. " seconds before you can call again" }
        })
        return
    end
    
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local name = GetPlayerName(PlayerId())
    local description = table.concat(args, ' ')
    
    
    if description == '' then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = { "Emegency Scanner", "^1Did you mean to describe your call too?" }
        })
        return
    end
    
    TriggerServerEvent('tracka_alert:new', name, description, playerPos)
    onCooldown = true
    SetTimeout(cooldown * 1000, function()
        onCooldown = false
    end)
end, false)


