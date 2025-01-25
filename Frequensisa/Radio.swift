//
//  Radio.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 20/01/2025.
//

import Foundation

struct Radio: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let url: String

    // Pour la création d'une nouvelle radio
    init(name: String, category: String, url: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.url = url
    }

    // Pour une radio existante (depuis la base)
    init(id: UUID, name: String, category: String, url: String) {
        self.id = id
        self.name = name
        self.category = category
        self.url = url
    }
}
