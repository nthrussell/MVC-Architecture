//
//  SpritesMode.swift
//  MVC-Architecture
//
//  Created by russel on 12/7/24.
//
import CoreData

struct SpritesModel: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

extension SpritesModel: ModelEntityMapProtocol {
    typealias EntityType = Sprite

    func mapToEntity(_ context: NSManagedObjectContext) -> Sprite {
        let sprite: Sprite = .init(context: context)
        sprite.frontDefault = frontDefault
        return sprite
    }
    
    static func mapFromEntity(_ entity: Sprite) -> Self {
        return .init(frontDefault: entity.frontDefault ?? "")
    }
    
}
