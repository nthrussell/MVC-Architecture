//
//  PokemonDetailModel.swift
//  MVC-Architecture
//
//  Created by russel on 3/7/24.
//

import Foundation

struct PokemonDetailModel: Codable {
    let height: Int
    let name: String
    let sprites: Sprites
    let weight: Int
}

class Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
