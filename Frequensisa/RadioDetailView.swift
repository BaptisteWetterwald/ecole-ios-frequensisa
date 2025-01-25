//
//  RadioDetailView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 21/01/2025.
//

import SwiftUI
import AVKit

struct RadioDetailView: View {
    @ObservedObject var playerManager = RadioPlayerManager.shared // Utilisation du gestionnaire global
    @Binding var radio: Radio

    var body: some View {
        VStack {
            Spacer()
            
            // Nom et catégorie de la radio
            VStack(spacing: 10) {
                Text(radio.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(radio.category)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()

            // Boutons Play et Pause
            HStack {
                Spacer()
                Button(action: {
                    playerManager.play(radio: radio)
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(playerManager.isPlaying && playerManager.currentRadio?.id == radio.id ? .gray : .blue)
                        .opacity(playerManager.isPlaying && playerManager.currentRadio?.id == radio.id ? 0.5 : 1)
                }
                .disabled(playerManager.isPlaying && playerManager.currentRadio?.id == radio.id)

                Spacer()

                Button(action: {
                    playerManager.pause()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(playerManager.isPlaying ? .red : .gray)
                        .opacity(playerManager.isPlaying ? 1 : 0.5)
                }
                .disabled(!playerManager.isPlaying)

                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddRadioView(radio: radio) { updatedRadio in
                    self.radio = updatedRadio
                }) {
                    Text("Modifier")
                }
            }
        }
    }
}
