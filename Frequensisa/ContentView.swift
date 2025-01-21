//
//  ContentView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 09/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showList: Bool = false // Variable pour basculer entre les vues

    var body: some View {
        if showList {
            RadioListView()
        } else {
            WelcomeAnimationView(showList: $showList)
        }
    }
}

#Preview {
    ContentView()
}
