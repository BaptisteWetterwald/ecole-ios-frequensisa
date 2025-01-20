//
//  ContentView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald on 09/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showList: Bool = false // Variable pour basculer entre les vues

    var body: some View {
        if showList {
            RadioListView() // Affiche la liste des radios
        } else {
            WelcomeAnimationView(showList: $showList) // Affiche l'écran d'animation
        }
    }
}

#Preview {
    ContentView()
}
