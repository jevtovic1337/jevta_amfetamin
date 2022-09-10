ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('revolucija:dajbure')
AddEventHandler('revolucija:dajbure', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("amphetamine").count
    if xPlayer then
        if GetPlayerPing(source) >= 150 then
            xPlayer.showNotification("Your connection is not stable!")
        else
            if item < 2 then
                xPlayer.addInventoryItem("amphetamine", 1)
                xPlayer.showNotification("You have got an amphetamine!")
            else
                xPlayer.showNotification("You have exceeded your inventory limit!")
            end
        end
    end
end)

ESX.RegisterServerCallback("getAmfetaminLimit", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("amphetamine").count
    if xPlayer then
        if GetPlayerPing(source) >= 150 then
            xPlayer.showNotification("Your connection is not stable!")
        else
            if item < 2 then
                cb(true)
            else
                cb(false)
            end
        end
    end
end)

ESX.RegisterUsableItem('amphetamine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("amphetamine").count
    if xPlayer then
        if item <= 2 then
            xPlayer.triggerEvent('jevta:dodajhelt')
        else
            xPlayer.showNotification("You don't have enough amphetamine!")
        end
    end
end)

RegisterServerEvent('revolucija:removeAmfetamin')
AddEventHandler('revolucija:removeAmfetamin', function(kod)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("amphetamine").count
    if item <= 2 then
        if kod == "JEBEMTIMATER" then
            xPlayer.removeInventoryItem("amphetamine", 1)
        else
            xPlayer.kick("citer")
        end
    else
        xPlayer.showNotification("You don't have enough amphetamine!")
    end
end)
