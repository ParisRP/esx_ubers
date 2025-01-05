// Fonction pour envoyer une requête au serveur et démarrer la mission Uber
document.getElementById('start-job').addEventListener('click', function() {
    // Envoi d'un événement au serveur pour démarrer la course
    fetch('https://votre-serveur/esx_ubers:startUberJob', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ start: true })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Mise à jour de l'interface avec les informations de mission
            document.getElementById('destination').textContent = data.destination;  // Exemple de destination
            document.getElementById('distance').textContent = data.distance;  // Exemple de distance
            document.getElementById('start-job').disabled = true;  // Désactiver le bouton "Commencer"
            document.getElementById('complete-job').disabled = false;  // Activer le bouton "Terminer"
        } else {
            // Afficher un message d'erreur si la mission ne démarre pas
            alert('Erreur : Impossible de démarrer la course');
        }
    })
    .catch(error => {
        console.error('Erreur lors de la requête:', error);
    });
});

// Fonction pour envoyer une requête au serveur et terminer la mission Uber
document.getElementById('complete-job').addEventListener('click', function() {
    // Envoi d'un événement au serveur pour terminer la course
    fetch('https://votre-serveur/esx_ubers:completeUberJob', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ complete: true })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Mise à jour de l'interface avec la fin de la mission
            document.getElementById('destination').textContent = 'Course terminée';
            document.getElementById('distance').textContent = 'Récompense : ' + data.reward + '€';
            document.getElementById('complete-job').disabled = true;  // Désactiver le bouton "Terminer"
            document.getElementById('start-job').disabled = false;  // Réactiver le bouton "Commencer"
        } else {
            // Afficher un message d'erreur si la mission ne se termine pas correctement
            alert('Erreur : Impossible de terminer la course');
        }
    })
    .catch(error => {
        console.error('Erreur lors de la requête:', error);
    });
});
