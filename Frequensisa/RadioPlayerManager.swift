//
//  RadioPlayerManager.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 25/01/2025.
//

import Foundation
import AVFoundation

// Gestionnaire central pour le lecteur audio
class RadioPlayerManager: ObservableObject {
    static let shared = RadioPlayerManager() // Singleton pour une instance unique
    
    private var player: AVPlayer?
    @Published var isPlaying: Bool = false // État global de lecture
    @Published var currentRadio: Radio? // Radio actuellement en cours de lecture

    private init() {} // Empêche l'instanciation directe
    
    func play(radio: Radio) {
        // Si la radio en cours est déjà en lecture, continuer la lecture
        if currentRadio?.id == radio.id {
            player?.play()
            isPlaying = true
            return
        }
        
        // Arrêter la lecture actuelle
        stop()
        
        // Configurer le lecteur avec la nouvelle radio
        guard let url = URL(string: radio.url) else { return }
        player = AVPlayer(url: url)
        player?.play()
        currentRadio = radio
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        currentRadio = nil
    }
}
