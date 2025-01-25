//
//  RadioDatabase.swift
//  Frequensisa
//
//  Created by Baptiste Wetterwald and Marc Proux on 25/01/2025.
//

import Foundation
import SQLite3

class RadioDatabase {
    fileprivate let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    static let shared = RadioDatabase()
    
    private var db: OpaquePointer?

    // MARK: - Initialisation
    private init() {
        openDatabase()
        createTable()
        seedDatabaseIfNeeded()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    // MARK: - Ouverture de la base
    private func openDatabase() {
        // Chemin vers le répertoire Documents de l'app
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("radios.sqlite")

        // Ouvrir/créer la base
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Erreur lors de l'ouverture de la base de données.")
        }
    }
    
    // MARK: - Création de la table
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS radios (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            url TEXT NOT NULL
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            if let errorMessage = sqlite3_errmsg(db) {
                print("Erreur création table: \(String(cString: errorMessage))")
            }
        }
    }
    
    // MARK: - Pré-remplir la base
    private func seedDatabaseIfNeeded() {
        // Vérifier si la table est déjà remplie
        let existingRadios = fetchRadios()
        if existingRadios.isEmpty {
            let initialRadios = [
                Radio(name: "RTL", category: "Généraliste", url: "http://streaming.radio.rtl.fr/rtl-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg"),
                Radio(name: "Europe1", category: "Généraliste", url: "http://stream.europe1.fr/europe1.mp3"),
                Radio(name: "France Info", category: "Information", url: "http://direct.franceinfo.fr/live/franceinfo-midfi.mp3"),
                Radio(name: "NRJ Mulhouse", category: "Musique", url: "http://cdn.nrjaudio.fm/audio1/fr/40007/aac_64.mp3"),
                Radio(name: "Skyrock", category: "Musique", url: "http://www.skyrock.fm/stream.php/tunein16_128mp3.mp3"),
                Radio(name: "RTL2", category: "Musique", url: "http://streaming.radio.rtl2.fr/rtl2-1-44-128?listen=webCwsBCggNCQgLDQUGBAcGBg")
            ]
            
            for radio in initialRadios {
                addRadio(radio)
            }
        }
    }
    
    // MARK: - Create
    func addRadio(_ radio: Radio) {
        let insertQuery = "INSERT INTO radios (id, name, category, url) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            let resultID = sqlite3_bind_text(statement, 1, radio.id.uuidString, -1, SQLITE_TRANSIENT)
            let resultName = sqlite3_bind_text(statement, 2, radio.name, -1, SQLITE_TRANSIENT)
            let resultCat = sqlite3_bind_text(statement, 3, radio.category, -1, SQLITE_TRANSIENT)
            let resultURL = sqlite3_bind_text(statement, 4, radio.url, -1, SQLITE_TRANSIENT)
            // Vérification (facultative) :  si resultID != SQLITE_OK, on peut logguer l’erreur
            if sqlite3_step(statement) != SQLITE_DONE {
                if let errorMessage = sqlite3_errmsg(db) {
                    print("Erreur d'insertion: \(String(cString: errorMessage))")
                }
            }
        }

        sqlite3_finalize(statement)
    }
    
    // MARK: - Read
    func fetchRadios() -> [Radio] {
        let selectQuery = "SELECT id, name, category, url FROM radios;"
        var statement: OpaquePointer?
        var radios = [Radio]()
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                // id
                let idCString = sqlite3_column_text(statement, 0)
                let idString = idCString != nil ? String(cString: idCString!) : ""
                let uuid = UUID(uuidString: idString) ?? UUID()
                
                // name
                let nameCString = sqlite3_column_text(statement, 1)
                let name = nameCString != nil ? String(cString: nameCString!) : ""
                
                // category
                let categoryCString = sqlite3_column_text(statement, 2)
                let category = categoryCString != nil ? String(cString: categoryCString!) : ""
                
                // url
                let urlCString = sqlite3_column_text(statement, 3)
                let url = urlCString != nil ? String(cString: urlCString!) : ""
                
                radios.append(
                    Radio(id: uuid, name: name, category: category, url: url)
                )
            }
        }
        sqlite3_finalize(statement)
        return radios
    }
    
    // MARK: - Update
    func updateRadio(_ radio: Radio) {
        let updateQuery = "UPDATE radios SET name = ?, category = ?, url = ? WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, radio.name, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 2, radio.category, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 3, radio.url, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 4, radio.id.uuidString, -1, SQLITE_TRANSIENT)

            
            if sqlite3_step(statement) != SQLITE_DONE {
                if let errorMessage = sqlite3_errmsg(db) {
                    print("Erreur update: \(String(cString: errorMessage))")
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - Delete
    func deleteRadio(_ radio: Radio) {
        let deleteQuery = "DELETE FROM radios WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, radio.id.uuidString, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                if let errorMessage = sqlite3_errmsg(db) {
                    print("Erreur delete: \(String(cString: errorMessage))")
                }
            }
        }
        sqlite3_finalize(statement)
    }
}
