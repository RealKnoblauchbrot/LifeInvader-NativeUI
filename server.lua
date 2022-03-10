local lastAdvertisement = nil

RegisterNetEvent('lifeinvader:sendMessage', function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.cost then
        if lastAdvertisement ~= nil then

            local minutes = os.difftime(tonumber(os.time()), lastAdvertisement) / 60
            if minutes >= Config.cooldown then
                lastAdvertisement = tonumber(os.time())
                sendAdvertisement(xPlayer, message)
            else
                xPlayer.showNotification(string.format(Config.locale.CurrentlyOnCooldown, ESX.Math.Round(Config.cooldown - minutes, 2)))
            end
        else
            lastAdvertisement = tonumber(os.time())
            sendAdvertisement(xPlayer, message)
        end
    end
end)

function sendAdvertisement(xPlayer, message)
    xPlayer.removeMoney(Config.cost)
    TriggerClientEvent('lifeinvader:sendNotification', -1, message)
    local embed = {
        {
            ["color"] = 15158332,
            ["title"] = string.format(Config.locale.PostedAdvertisementLog, xPlayer.getName()),
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%c")
            }
        }
    }
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.name, avatar_url= "https://wiki.rage.mp/images/5/5e/Char_lifeinvader.jpg" ,embeds = embed}), { ['Content-Type']= 'application/json' })
end