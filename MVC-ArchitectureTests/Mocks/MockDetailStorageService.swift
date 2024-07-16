//
//  MockDetailStorageService.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import XCTest

@testable import MVC_Architecture

class MockDetailStorageService: DetailStorageService {
    required init(storageProvider: MVC_Architecture.StorageProvider) { }
    
    func checkIfFavourite(data: MVC_Architecture.PokemonDetailModel) -> Bool {
        false
    }
    
    func saveOrDelete(with data: MVC_Architecture.PokemonDetailModel) {
        
    }
}
