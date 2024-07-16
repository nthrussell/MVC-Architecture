//
//  DetailStorageService.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import CoreData

protocol DetailStorageService {
    init(storageProvider: StorageProvider)
    func checkIfFavourite(data: PokemonDetailModel) -> Bool
    func saveOrDelete(with data: PokemonDetailModel)
}

class DefaultDetailStorageService: DetailStorageService {
    
    var storageProvider: StorageProvider
    
    required init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
    
    func checkIfFavourite(data: PokemonDetailModel) -> Bool {
        storageProvider.checkIfFavourite(name: data.name)
    }
    
    func saveOrDelete(with data: PokemonDetailModel) {
        if checkIfFavourite(data: data) {
            storageProvider.delete(name: data.name)
        } else {
            _ = data.mapToEntity(storageProvider.persistentContainer.viewContext)
            storageProvider.saveContext()
        }
    }
}
