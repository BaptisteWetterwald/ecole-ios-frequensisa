//
//  ContentView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald on 09/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var logoScale: CGFloat = 0.5
    @State private var textOpacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var logoOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var titleOffset: CGSize = CGSize(width: 0, height: 130) // Offset pour le titre, peut-être remplacer par des contraintes pour gérer tous les écrans
    @State private var isLogoVisible: Bool = true
    @State private var isTitleVisible: Bool = true
    
    var body: some View {
        ZStack {
            // Background noir
            Color.black
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        backgroundOpacity = 1.0
                    }
                }
            
            // Background logo
            Image("logo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.horizontal)
                .scaleEffect(logoScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        logoScale = 1.0
                    }
                }
                .offset(logoOffset) // Applique l'offset sur l'image
                .opacity(isLogoVisible ? 1.0 : 0.0) // Gère la visibilité du logo
        
            Text("Frequensisa FM 🎵")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(textOpacity)
                .multilineTextAlignment(.center)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                        textOpacity = 1.0
                    }
                }
                .offset(titleOffset)
                .padding()
                .opacity(isTitleVisible ? 1.0 : 0.0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.6).delay(0.5)) {
                            
                            // On balaye le logo vers le haut puis on le met invisible
                            self.logoOffset = CGSize(width: 0, height: -500)
                            self.isLogoVisible = false

                            // Idem pour le titre mais vers le bas
                            self.titleOffset = CGSize(width: 0, height: 500) //
                            self.isTitleVisible = false
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
