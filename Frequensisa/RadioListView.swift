//
//  RadioListView.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 20/01/2025.
//

import SwiftUI

struct RadioListView: View {
    @ObservedObject var playerManager = RadioPlayerManager.shared
    @State private var radios: [Radio] = []
    @State private var visibleItems: Set<UUID> = []

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedRadios.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)
                        .font(.headline)
                        .foregroundColor(.black)
                    ) {
                        // On itère DIRECTEMENT sur [Radio]
                        ForEach(groupedRadios[category]!, id: \.id) { radio in
                            NavigationLink(
                                destination: RadioDetailView(radio: bindingForRadio(radio))
                            ) {
                                HStack {
                                    Text(radio.name)
                                        .foregroundColor(.primary)
                                        .opacity(visibleItems.contains(radio.id) ? 1 : 0)
                                        .animation(.easeInOut(duration: 1.5), value: visibleItems)
                                        .onAppear { showItemWithDelay(radio.id) }
                                    
                                    if playerManager.currentRadio?.id == radio.id {
                                        Image(systemName: "waveform.path")
                                            .foregroundColor(.blue)
                                    }
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
                        RadioDatabase.shared.addRadio(newRadio)
                        loadRadios()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                loadRadios()
            }
        }
    }

    // Charge les radios depuis la base
    private func loadRadios() {
        radios = RadioDatabase.shared.fetchRadios()
    }

    // Renvoie [String: [Radio]] au lieu de [String: [Int]]
    private var groupedRadios: [String: [Radio]] {
        Dictionary(grouping: radios, by: { $0.category })
    }

    // L'ordre d’affichage effectif (catégorie triée puis radios)
    private var radiosInDisplayOrder: [Radio] {
        let categories = groupedRadios.keys.sorted()
        return categories.flatMap { groupedRadios[$0]! }
    }

    private func showItemWithDelay(_ id: UUID) {
        guard let index = radiosInDisplayOrder.firstIndex(where: { $0.id == id }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + Double(index) * 0.2) {
            visibleItems.insert(id)
        }
    }

    // Trouve l'index dans 'radios' pour créer un Binding
    private func bindingForRadio(_ radio: Radio) -> Binding<Radio> {
        guard let index = radios.firstIndex(where: { $0.id == radio.id }) else {
            fatalError("Radio non trouvée")
        }
        return $radios[index]
    }
}


#Preview {
    RadioListView()
}
