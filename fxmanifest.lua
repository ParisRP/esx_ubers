fx_version 'cerulean'
game 'gta5'

author 'VotreNom'
description 'Job Uber réaliste pour ESX Legacy'
version '1.0.0'

-- Dépendances de la ressource
dependency 'es_extended'

-- Fichiers à inclure pour le client
client_scripts {
    'client.lua',  -- Le script côté client
}

-- Fichiers à inclure pour le serveur
server_scripts {
    'server.lua',  -- Le script côté serveur
}

-- Fichiers pour les métadonnées et les interfaces
ui_page 'html/index.html'

-- Définir les ressources supplémentaires (comme des fichiers HTML, CSS, JS si nécessaire)
files {
    'html/index.html',
    'html/styles.css',
    'html/scripts.js',
}

-- Ajouter des permissions pour le serveur si nécessaire
escrow_ignore {
    'server.lua',
    'client.lua',
    'fxmanifest.lua',
}
