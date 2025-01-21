//
//  RadioListView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald on 20/01/2025.
//

import SwiftUI

struct RadioListView: View {
    @State private var radios: [Radio] = [
        Radio(name: "RTL", category: "Généraliste", url: "http://streaming.radio.rtl.fr/rtl-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg"),
        Radio(name: "Europe1", category: "Généraliste", url:  "http://stream.europe1.fr/europe1.mp3"),
        Radio(name: "France Info", category: "Information", url: "http://direct.franceinfo.fr/live/franceinfo-midfi.mp3"),
        Radio(name: "NRJ Mulhouse", category: "Musique", url: "http://cdn.nrjaudio.fm/audio1/fr/40007/aac_64.mp3"),
        Radio(name: "Skyrock", category: "Musique", url: "http://www.skyrock.fm/stream.php/tunein16_128mp3.mp3"),
        Radio(name: "RTL2", category: "Musique", url: "http://streaming.radio.rtl2.fr/rtl2-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg")
    ]
    
    @State private var visibleItems: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedRadios.keys.sorted(), id: \ .self) { category in
                    Section(header: Text(category).font(.headline)) {
                        ForEach(groupedRadios[category]!.indices, id: \ .self) { index in
                            NavigationLink(destination: RadioDetailView(radio: $radios[groupedRadios[category]![index]])) {
                                Text(radios[groupedRadios[category]![index]].name)
                                    .opacity(visibleItems.contains(radios[groupedRadios[category]![index]].id) ? 1 : 0)
                                    .animation(.easeInOut(duration: 1.5), value: visibleItems)
                                    .onAppear {
                                        showItemWithDelay(radios[groupedRadios[category]![index]].id)
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Radios")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddRadioView(radio: nil) { newRadio in
                        radios.append(newRadio)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func showItemWithDelay(_ id: UUID) {
        let index = radios.firstIndex(where: { $0.id == id }) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + Double(index) * 0.2) {
            visibleItems.insert(id)
        }
    }
    
    // Fonction pour regrouper les radios par catégories
    var groupedRadios: [String: [Int]] {
        Dictionary(grouping: radios.indices, by: { radios[$0].category })
    }
}

#Preview {
    RadioListView()
}
