//
//  RadioListView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald on 20/01/2025.
//

import SwiftUI

struct RadioListView: View {
    let radios: [Radio] = [
        Radio(name: "RTL", category: "Généraliste", url: "http://streaming.radio.rtl.fr/rtl-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg"),
        Radio(name: "Europe1", category: "Généraliste", url:  "http://stream.europe1.fr/europe1.mp3"),
        Radio(name: "France Info", category: "Information", url: "http://direct.franceinfo.fr/live/franceinfo-midfi.mp3"),
        Radio(name: "NRJ Mulhouse", category: "Musique", url: " http://cdn.nrjaudio.fm/audio1/fr/40007/aac_64.mp3"),
        Radio(name: "Skyrock", category: "Musique", url: "http://www.skyrock.fm/stream.php/tunein16_128mp3.mp3"),
        Radio(name: "RTL2", category: "Musique", url: "http://streaming.radio.rtl2.fr/rtl2-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg")
    ]
    
    @State private var visibleItems: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedRadios.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category).font(.headline)) {
                        ForEach(groupedRadios[category]!) { radio in
                            HStack {
                                Text(radio.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .opacity(visibleItems.contains(radio.id) ? 1 : 0)
                            .animation(.easeInOut(duration: 1.5), value: visibleItems)
                            .onAppear {
                                showItemWithDelay(radio.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Radios")
        }
    }
    
    private func showItemWithDelay(_ id: UUID) {
        let index = radios.firstIndex(where: { $0.id == id }) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + Double(index) * 0.2) {
            visibleItems.insert(id)
        }
    }
    
    // Fonction pour regrouper les radios par catégories
    var groupedRadios: [String: [Radio]] {
        Dictionary(grouping: radios, by: { $0.category })
    }
}

#Preview {
    RadioListView()
}
