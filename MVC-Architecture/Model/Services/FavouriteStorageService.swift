//
//  FavouriteStorageService.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import CoreData

protocol FavouriteStorageService {
    init(storageProvider: StorageProvider)
    func getAllFavourites() -> [PokemonDetailModel]
    func delete(data: PokemonDetailModel)
}

class DefaultFavouriteStorageService: FavouriteStorageService {
    var storageProvider: StorageProvider
    
    required init(storageProvider: StorageProvider = StorageProvider()) {
        self.storageProvider = storageProvider
    }
    
    func getAllFavourites() -> [PokemonDetailModel] {
        let value: [PokemonDetail] = storageProvider.getAllData()
        return value.map { PokemonDetailModel.mapFromEntity($0) }
    }
    
    func delete(data: PokemonDetailModel) {
        storageProvider.delete(name: data.name)
    }
}
