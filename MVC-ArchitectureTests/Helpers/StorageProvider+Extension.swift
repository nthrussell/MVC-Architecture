//
//  InMemoryStorageProvider.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import Foundation
import CoreData

@testable import MVC_Architecture

extension StorageProvider {
    func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(persistentContainer.viewContext)
        saveContext()
    }
}

extension StorageProvider {
    func deleteData(data: PokemonDetailModel) {
        delete(name: data.name)
    }
}
