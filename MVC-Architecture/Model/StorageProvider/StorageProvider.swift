//
//  StorageProvider.swift
//  MVC-Architecture
//
//  Created by russel on 5/7/24.
//
import CoreData

class StorageProvider {
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
    func saveData(data: PokemonDetailModel) {
        let pokemonDetail = PokemonDetail(context: persistentContainer.viewContext)
        pokemonDetail.name = data.name
        pokemonDetail.height = Int64(data.height)
        pokemonDetail.weight = Int64(data.weight)
        
        let sprites = Sprite(context: persistentContainer.viewContext)
        sprites.frontDefault = data.sprites.frontDefault
        sprites.pokeDetail = pokemonDetail
        
        pokemonDetail.addToSprites(sprites)
        
        do {
            try persistentContainer.viewContext.save()
            print("pokemonDetail saved successfully")
        } catch {
            persistentContainer.viewContext.rollback()
            print("failed to save pokemonDetail:\(error)")
        }
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
            print("pokemonDetail saved successfully")
        } catch {
            persistentContainer.viewContext.rollback()
            print("failed to save pokemonDetail:\(error)")
        }
    }

}

extension StorageProvider {
    func checkIfPokemonIsFavourite(data: PokemonDetailModel) -> Bool {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", data.name)
        
        let pokeData = try? persistentContainer.viewContext.fetch(fetchRequest)
        guard pokeData?.count ?? 0 > 0 else { return false }
        return pokeData?[0].name == data.name
    }
}

extension StorageProvider {
    func getAllData() -> [PokemonDetail] {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("failed to fetch PokemonDetail with error:\(error)")
            return []
        }
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
            debugPrint("CoreData Error")
        }
    }
}
