//
//  Radio.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 21/01/2025.
//

import SwiftUI

struct AddRadioView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var category: String
    @State private var url: String

    var radio: Radio? // nil si création, non-nil si édition
    var onSave: (Radio) -> Void
    var onDelete: (() -> Void)? // <--- callback pour fermer la vue détail

    init(radio: Radio?,
         onSave: @escaping (Radio) -> Void,
         onDelete: (() -> Void)? = nil)
    {
        _name = State(initialValue: radio?.name ?? "")
        _category = State(initialValue: radio?.category ?? "")
        _url = State(initialValue: radio?.url ?? "")
        self.radio = radio
        self.onSave = onSave
        self.onDelete = onDelete
    }

    var body: some View {
        Form {
            Section(header: Text("Informations de la radio")) {
                TextField("Nom", text: $name)
                    .textInputAutocapitalization(.words)
                TextField("Catégorie", text: $category)
                    .textInputAutocapitalization(.words)
                TextField("URL", text: $url)
                    .keyboardType(.URL)
            }

            // Bouton Supprimer si on modifie une radio existante
            if let existingRadio = radio {
                Section {
                    Button("Supprimer la radio", role: .destructive) {
                        if RadioPlayerManager.shared.currentRadio?.id == existingRadio.id {
                            RadioPlayerManager.shared.stop()
                        }
                        RadioDatabase.shared.deleteRadio(existingRadio)
                        dismiss()
                        DispatchQueue.main.async {
                            onDelete?()
                        }
                    }
                }
            }
        }
        .navigationTitle(radio == nil ? "Ajouter une radio" : "Modifier la radio")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Enregistrer") {
                    saveRadio()
                }
                .disabled(name.isEmpty || category.isEmpty || url.isEmpty)
            }
        }
    }

    private func saveRadio() {
        if let existingRadio = radio {
            let updatedRadio = Radio(id: existingRadio.id, name: name, category: category, url: url)
            RadioDatabase.shared.updateRadio(updatedRadio)
            onSave(updatedRadio)
        } else {
            let newRadio = Radio(name: name, category: category, url: url)
            RadioDatabase.shared.addRadio(newRadio)
            onSave(newRadio)
        }
        dismiss()
    }
}

#Preview {
    AddRadioView(radio: nil, onSave: { _ in })
}
