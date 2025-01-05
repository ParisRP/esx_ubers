local ESX = nil
local inUberJob = false
local passengerPed = nil
local destinationCoords = nil
local destinationBlip = nil

-- Récupérer l'objet ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Fonction pour démarrer une course Uber
function StartUberJob()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if IsPedInAnyVehicle(playerPed, false) then
        ESX.ShowNotification("Course Uber acceptée ! Suivez la destination.")

        -- Générer une destination aléatoire dans un rayon de 2000 unités
        destinationCoords = vector3(math.random(-2000, 2000), math.random(-2000, 2000), 30.0)  -- Coordonnées aléatoires
        destinationBlip = AddBlipForCoord(destinationCoords)
        SetBlipSprite(destinationBlip, 1)
        SetBlipColour(destinationBlip, 2)
        SetBlipScale(destinationBlip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Destination Uber")
        EndTextCommandSetBlipName(destinationBlip)

        inUberJob = true
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour commencer la course.")
    end
end

-- Fonction pour terminer la course Uber
function CompleteUberJob()
    if inUberJob then
        ESX.ShowNotification("Course terminée ! Vous avez gagné de l'argent.")

        -- Récompenser le joueur pour la course
        local reward = math.random(50, 100)  -- Récompense aléatoire entre 50 et 100
        TriggerServerEvent('esx_ubers:addMoneyForJob', reward)

        -- Supprimer le blip de destination
        RemoveBlip(destinationBlip)

        -- Réinitialiser les variables
        inUberJob = false
        destinationCoords = nil
        destinationBlip = nil
    else
        ESX.ShowNotification("Vous n'êtes pas en train de conduire un passager.")
    end
end

-- Vérifier la distance avec la destination
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if inUberJob then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, destinationCoords.x, destinationCoords.y, destinationCoords.z)

            -- Si le joueur est proche de la destination, terminer la course
            if distance < 10.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour terminer la course.")
                if IsControlJustPressed(0, 38) then  -- Touche E
                    CompleteUberJob()
                end
            end
        end
    end
end)

-- Interaction pour démarrer une course Uber à un point de départ
Citizen.CreateThread(function()
    local UberStartPoints = {
        {x = -44.25, y = -1682.84, z = 29.40}, -- Exemple de point de départ
        {x = 213.53, y = -766.23, z = 29.44},  -- Autre point
    }

    for _, point in ipairs(UberStartPoints) do
        local blip = AddBlipForCoord(point.x, point.y, point.z)
        SetBlipSprite(blip, 280)  -- Icône de taxi
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Point de départ Uber")
        EndTextCommandSetBlipName(blip)
    end

    -- Interaction pour accepter une course Uber
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, point in ipairs(UberStartPoints) do
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, point.x, point.y, point.z)
            
            if distance < 5.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accepter une course Uber.")
                if IsControlJustPressed(0, 38) then  -- Touche E
                    TriggerEvent('esx_ubers:startUberJob')
                end
            end
        end
    end
end)

-- Démarrer une course Uber via un événement
RegisterNetEvent('esx_ubers:startUberJob')
AddEventHandler('esx_ubers:startUberJob', function()
    StartUberJob()
end)
