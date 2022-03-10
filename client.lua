local isNearPed, isPedLoaded, isAtPed = false, false, false
local npc = nil
_menuPool = NativeUI.CreatePool()
local mainMenu


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500) 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k,v in pairs(Config.locations) do
        local distance = #(coords - v.coords)
        isNearPed = false
        isAtPed = false

        if distance < 32.0 then
            isNearPed = true
            if not isPedLoaded then
                RequestModel(Config.pedModel)
                while not HasModelLoaded(Config.pedModel) do
                    Wait(10)
                end

                npc = CreatePed(4, Config.pedModel, v.coords.x, v.coords.y, v.coords.z - 1, v.heading, false, false)
                FreezeEntityPosition(npc, true)
                SetEntityHeading(npc, v.heading)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                
                isPedLoaded = true
            end
        end
        
        if isPedLoaded and not isNearPed then
            DeleteEntity(npc)
            SetModelAsNoLongerNeeded(Config.pedModel)
            isPedLoaded = false
        end

        if distance < 2.5 then
            isAtPed = true
        end
    end
   end
end)

Citizen.CreateThread(function()
    while true do
        _menuPool:ProcessMenus()

        if isAtPed then
            ShowHelpNotification(string.format(Config.locale.PressE, Config.cost))
            if IsControlJustReleased(0, 38) then
                if ESX.GetPlayerData().accounts[2].money >= Config.cost then
                    openMenu()
                else
                    SendNotification(Config.locale.NotEnoughMoney)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

function SendNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function ShowHelpNotification(message)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function openMenu()

    mainMenu = NativeUI.CreateMenu(Config.locale.Menu.title, Config.locale.Menu.description)
    _menuPool:Add(mainMenu)

    mainMenu:Visible(true)
    local messageMenu = NativeUI.CreateItem(Config.locale.Menu.SendTitle, string.format(Config.locale.Menu.SendDescription, Config.cost))
    mainMenu:AddItem(messageMenu)
    messageMenu.Activated = function(sender, item, index)
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 128 + 1)
        while(UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if(GetOnscreenKeyboardResult()) then
            TriggerServerEvent('lifeinvader:sendMessage', GetOnscreenKeyboardResult())
        end
    end
end

RegisterNetEvent('lifeinvader:sendNotification', function(message)
    AddTextEntry('lifeInvaderNotif', message)
    BeginTextCommandThefeedPost('lifeInvaderNotif')
    EndTextCommandThefeedPostMessagetext('CHAR_LIFEINVADER', 'CHAR_LIFEINVADER', false, 1, Config.name, Config.locale.adDescription)
end)

function CreateBlips()
    blipSettings = Config.blips
    for k,v in pairs(Config.locations) do
        local blip = AddBlipForCoord(v.coords)

        SetBlipSprite(blip, blipSettings.sprite)
        SetBlipColour(blip, blipSettings.color)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, blipSettings.scale)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.name)
        EndTextCommandSetBlipName(blip)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        CreateBlips()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    CreateBlips()
end)