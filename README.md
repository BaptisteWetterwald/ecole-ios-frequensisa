# Frequensisa

Projet de 3e année : développement d'une application iOS d'écoute de radios

Réalisé par Marc Proux et Baptiste Wetterwald

<img width="1024" height="1024" alt="appicon" src="https://github.com/user-attachments/assets/3f6887b7-27cc-44ab-b2ca-35e727180695" />

## Prérequis

Développé sur XCode V16.2 pour les IPhone sous iOS 18.0

## Architecture

Frequensisa est composé d'un écran qui liste les radios (RadioListView.swift) enregistrées, triées par catégorie, et affiche la radio en cours d'écoute.
De cet écran, on peut aller sur le détail d'une radio (RadioDetailView.swift) afin de l'écouter.

De ces deux écrans, on peut accéder à l'écran d'ajout/édition d'une radio (RadioAddView.swift) qui permet de créer, modifier ou supprimer une radio.

La persistance des données est assurée par une base SQlite (module SQlite3 de Swift), gérée par le fichier RadioDatabase.swift et utilise l'objet Radio présent dans Radio.swift

La lecture d'une radio est effectuée grâce à un AVPlayer, partagé entre tous les composants et géré dans le fichier RadioPlayerManager.swift.


https://github.com/user-attachments/assets/d9484375-3d38-4aad-95b6-54bb37c3e8d8
