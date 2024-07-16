//
//  InMemoryStorageProvider.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import Foundation
import CoreData

@testable import MVC_Architecture

class InMemoryStorageProvider: StorageProvider {
    override init() {
        super.init()
        
        let storageDescription = NSPersistentStoreDescription()
        storageDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "PokemonDataModel")
        container.persistentStoreDescriptions = [storageDescription]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        persistentContainer = container
    }
}
