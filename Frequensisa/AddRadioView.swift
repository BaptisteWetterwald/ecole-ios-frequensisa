import SwiftUI

struct AddRadioView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var category: String
    @State private var url: String
    var onSave: (Radio) -> Void

    init(radio: Radio?, onSave: @escaping (Radio) -> Void) {
        _name = State(initialValue: radio?.name ?? "")
        _category = State(initialValue: radio?.category ?? "")
        _url = State(initialValue: radio?.url ?? "")
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section(header: Text("Informations de la Radio")) {
                TextField("Nom", text: $name)
                    .textInputAutocapitalization(.words)

                TextField("Catégorie", text: $category)
                    .textInputAutocapitalization(.words)

                TextField("URL", text: $url)
                    .keyboardType(.URL)
            }
        }
        .navigationTitle(name.isEmpty ? "Ajouter une Radio" : "Modifier la Radio")
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
        let newRadio = Radio(name: name, category: category, url: url)
        onSave(newRadio)
        dismiss()
    }
}

#Preview {
    AddRadioView(radio: nil, onSave: { _ in })
}
