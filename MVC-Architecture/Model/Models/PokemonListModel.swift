//
//  PokemonListModel.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import Foundation

struct PokemonListModel: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PokemonList]
}

// MARK: - Result
struct PokemonList: Codable {
    let name: String
    let url: String
}
