//
//  RadioDetailView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 21/01/2025.
//

import SwiftUI
import AVKit

struct RadioDetailView: View {
    @Binding var radio: Radio
    @State private var isPlaying = false // État de lecture
    @State private var player: AVPlayer? // Player pour gérer le flux audio

    var body: some View {
        VStack {
            Spacer()
            // Nom et catégorie de la radio
            VStack(spacing: 10) {
                Text(radio.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(radio.category)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()

            // Footer avec boutons Play et Pause
            HStack {
                Spacer()
                Button(action: {
                    playRadio()
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isPlaying ? .gray : .blue)
                        .opacity(isPlaying ? 0.5 : 1)
                }
                .disabled(isPlaying)

                Spacer()

                Button(action: {
                    pauseRadio()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isPlaying ? .red : .gray)
                        .opacity(isPlaying ? 1 : 0.5)
                }
                .disabled(!isPlaying)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            setupPlayer()
        }
        //.navigationTitle("Super choix !") // En commentaire pcqu'on ne peut pas le mettre en white
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddRadioView(radio: radio) { updatedRadio in
                    self.radio = updatedRadio
                }) {
                    Text("Modifier")
                }
            }
        }
        .background(Image("round").resizable().scaledToFill().ignoresSafeArea())
    }

    private func setupPlayer() {
        guard let url = URL(string: radio.url) else { return }
        player = AVPlayer(url: url)
    }

    private func playRadio() {
        isPlaying = true
        player?.play()
    }

    private func pauseRadio() {
        isPlaying = false
        player?.pause()
    }
}
