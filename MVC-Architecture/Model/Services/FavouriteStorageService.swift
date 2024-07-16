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
    
    required init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
    
    func getAllFavourites() -> [PokemonDetailModel] {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let value = try storageProvider.persistentContainer.viewContext.fetch(fetchRequest)
            return value.map { PokemonDetailModel.mapFromEntity($0) }
        } catch {
            debugPrint("CoreData Get All Favourites Error")
            return []
        }
    }
    
    func delete(data: PokemonDetailModel) {
        do {
            let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", data.name)
            
            let pokemonsDetails = try storageProvider.persistentContainer.viewContext.fetch(fetchRequest)
            for pokemon in pokemonsDetails {
                storageProvider.persistentContainer.viewContext.delete(pokemon)
            }
            storageProvider.saveContext()
        } catch {
            debugPrint("CoreData Delete Error")
        }
    }
}
