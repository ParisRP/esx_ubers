local ESX = nil

-- Récupérer l'objet ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Événement pour ajouter de l'argent après une course Uber réussie
RegisterServerEvent('esx_ubers:addMoneyForJob')
AddEventHandler('esx_ubers:addMoneyForJob', function(reward)
    local _source = source  -- ID du joueur qui a effectué la course
    local xPlayer = ESX.GetPlayerFromId(_source)  -- Récupère l'objet du joueur

    -- Vérifier si le joueur existe (il pourrait être déconnecté)
    if xPlayer then
        -- Ajouter de l'argent au joueur
        xPlayer.addMoney(reward)

        -- Envoyer une notification au joueur pour lui indiquer la récompense
        TriggerClientEvent('esx:showNotification', _source, "Vous avez gagné ~g~" .. reward .. "€ ~w~pour la course Uber.")

        -- Ajouter une entrée dans les logs (facultatif, pour les administrateurs)
        print(('esx_ubers: %s a gagné %d€ pour une course Uber.'):format(xPlayer.getName(), reward))
    else
        print("Le joueur n'a pas pu être trouvé ou il est déconnecté.")
    end
end)

-- Événement pour envoyer une notification au serveur (facultatif, peut être personnalisé)
RegisterServerEvent('esx_ubers:notifyServer')
AddEventHandler('esx_ubers:notifyServer', function(message)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        -- Optionnellement, affiche un message dans le chat de tout le serveur
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Uber Job]", message}
        })
    end
end)

-- Gérer les données des joueurs (niveau de réputation, course réussie, etc.)
RegisterServerEvent('esx_ubers:updatePlayerReputation')
AddEventHandler('esx_ubers:updatePlayerReputation', function(isSuccessful)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local reputation = xPlayer.get("uber_reputation") or 0  -- Récupérer la réputation, ou 0 si pas encore défini

        if isSuccessful then
            reputation = reputation + 1  -- Augmenter la réputation si la course est réussie
            TriggerClientEvent('esx:showNotification', _source, "Votre réputation Uber a augmenté !")
        else
            reputation = math.max(0, reputation - 1)  -- Réduire la réputation si la course échoue
            TriggerClientEvent('esx:showNotification', _source, "Votre réputation Uber a diminué.")
        end

        -- Mettre à jour la réputation du joueur
        xPlayer.set("uber_reputation", reputation)
    end
end)

-- Commande admin pour voir la réputation d'un joueur (facultatif)
ESX.RegisterCommand('reputation', 'admin', function(xPlayer, args, showError)
    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)

        if targetPlayer then
            local reputation = targetPlayer.get("uber_reputation") or 0
            TriggerClientEvent('esx:showNotification', xPlayer.source, "La réputation Uber de " .. targetPlayer.getName() .. " est de: " .. reputation)
        else
            showError("Le joueur n'a pas été trouvé.")
        end
    else
        showError("ID du joueur invalide.")
    end
end, false, {help = "Voir la réputation Uber d'un joueur", validate = false})

-- Commande pour réinitialiser la réputation d'un joueur (facultatif, utile pour les admins)
ESX.RegisterCommand('resetReputation', 'admin', function(xPlayer, args, showError)
    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)

        if targetPlayer then
            targetPlayer.set("uber_reputation", 0)  -- Réinitialiser la réputation
            TriggerClientEvent('esx:showNotification', xPlayer.source, "La réputation Uber de " .. targetPlayer.getName() .. " a été réinitialisée.")
        else
            showError("Le joueur n'a pas été trouvé.")
        end
    else
        showError("ID du joueur invalide.")
    end
end, false, {help = "Réinitialiser la réputation Uber d'un joueur", validate = false})
