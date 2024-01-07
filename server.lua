RegisterNetEvent('tracka_alert:new')
AddEventHandler('tracka_alert:new', function(name, description, cords)
    TriggerClientEvent('tracka_alert:new', -1, name, description, cords)
end)
