//
//  PokemonDetailModel.swift
//  MVC-Architecture
//
//  Created by russel on 3/7/24.
//

import Foundation
import CoreData

struct PokemonDetailModel: Codable {
    let height: Int
    let name: String
    let sprites: SpritesModel
    let weight: Int
}

extension PokemonDetailModel: ModelEntityMapProtocol {
    typealias EntityType = PokemonDetail

    func mapToEntity(_ context: NSManagedObjectContext) -> PokemonDetail {
        let pokemonDetail: PokemonDetail = .init(context: context)
        pokemonDetail.name = name
        pokemonDetail.height = Int64(height)
        pokemonDetail.weight = Int64(weight)
        
        let sprites:Sprite = .init(context: context)
        sprites.frontDefault = sprites.frontDefault
        sprites.pokeDetail = pokemonDetail
        
        pokemonDetail.addToSprites(sprites)
        
        return pokemonDetail
    }
    
    static func mapFromEntity(_ entity: PokemonDetail) -> PokemonDetailModel {
        
        guard let sprite = entity.sprites else {
            return .init(
                height: Int(entity.height),
                name: entity.name ?? "",
                sprites: SpritesModel(frontDefault: ""),
                weight: Int(entity.weight))
        }
        
        let spriteModel: SpritesModel = sprite.map { SpritesModel.mapFromEntity($0 as! Sprite) }.first! //SpritesModel(frontDefault: "")
        
//        for i in sprite {
//            spriteModel = SpritesModel.mapFromEntity(i as! Sprite)
//        }
                
        return .init(height: Int(entity.height),
                     name: entity.name ?? "",
                     sprites: spriteModel,
                     weight: Int(entity.weight))
    }
}


