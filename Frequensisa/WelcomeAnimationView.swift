//
//  WelcomeAnimationView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 20/01/2025.
//

import SwiftUI

struct WelcomeAnimationView: View {
    @Binding var showList: Bool // Utilisé pour basculer vers la vue des radios

    @State private var logoScale: CGFloat = 0.5
    @State private var textOpacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var logoOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var titleOffset: CGSize = CGSize(width: 0, height: 130)
    @State private var isLogoVisible: Bool = true
    @State private var isTitleVisible: Bool = true

    var body: some View {
        ZStack {
            // Fond noir
            Color.black
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        backgroundOpacity = 1.0
                    }
                }
            
            // Logo
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
                .offset(logoOffset)
                .opacity(isLogoVisible ? 1.0 : 0.0)
            
            // Titre
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
                            // Animation du logo et du titre
                            self.logoOffset = CGSize(width: 0, height: -500)
                            self.isLogoVisible = false
                            self.titleOffset = CGSize(width: 0, height: 500)
                            self.isTitleVisible = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            withAnimation {
                                self.showList = true // Passe à la liste
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    WelcomeAnimationView(showList: .constant(false))
}
