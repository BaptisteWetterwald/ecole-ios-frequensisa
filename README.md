# Frequensisa

Projet de 3e année : développement d'une application iOS d'écoute de radios

Réalisé par Marc Proux et Baptiste Wetterwald

## Prérequis

Développé sur XCode V16.2 pour les IPhone sous iOS 18.0

## Architecture

Frequensisa est composé d'un écran qui liste les radios (RadioListView.swift) enregistrées, triées par catégorie, et affiche la radio en cours d'écoute.
De cet écran, on peut aller sur le détail d'une radio (RadioDetailView.swift) afin de l'écouter.

De ces deux écrans, on peut accéder à l'écran d'ajout/édition d'une radio (RadioAddView.swift) qui permet de créer, modifier ou supprimer une radio.

La persistance des données est assurée par une base SQlite (module SQlite3 de Swift), gérée par le fichier RadioDatabase.swift et utilise l'objet Radio présent dans Radio.swift

La lecture d'une radio est effectuée grave à un AVPlayer, partagé entre tous les composant et gérer dans le fichier RadioPlayerManager.swift.
