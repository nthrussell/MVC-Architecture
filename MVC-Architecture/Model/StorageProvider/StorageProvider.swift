//
//  StorageProvider.swift
//  MVC-Architecture
//
//  Created by russel on 5/7/24.
//
import CoreData

class StorageProvider {
    static let shared = StorageProvider()

    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "PokemonDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreData failed to load with error:\(error)")
            }
        }
    }
}

extension StorageProvider {
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}

extension StorageProvider {
    func getAllData() -> [PokemonDetail] {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            debugPrint("CoreData Delete Error:\(error)")
            return []
        }
    }
}

extension StorageProvider {
    func checkIfFavourite(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let pokeData = try? persistentContainer.viewContext.fetch(fetchRequest)
        guard let pokeData = pokeData, pokeData.count > 0 else { return false }
        return pokeData.first?.name == name
    }
}

extension StorageProvider {
    func delete(name: String) {
        do {
            let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            let pokemonsDetails = try persistentContainer.viewContext.fetch(fetchRequest)
            for pokemon in pokemonsDetails {
                persistentContainer.viewContext.delete(pokemon)
            }
            saveContext()
        } catch {
            debugPrint("CoreData Delete Error:\(error)")
        }
    }
}
