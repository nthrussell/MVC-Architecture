//
//  MockHomeApiService.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import XCTest
import Combine

@testable import MVC_Architecture

class HomeApiServiceStub: HomeApiService {
    private let result: Result<PokemonListModel, Error>

    init(returning result: Result<PokemonListModel, Error>) {
        self.result = result
    }
    
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        return result.publisher
            // Use some delay to simulate the real world async behavior
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
