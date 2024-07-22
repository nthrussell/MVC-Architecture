//
//  MockDetailApiService.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import XCTest
import Combine

@testable import MVC_Architecture

class DetailApiServiceStub: DetailApiService {
    private let result: Result<PokemonDetailModel, Error>

    init(returning result: Result<PokemonDetailModel, Error>) {
        self.result = result
    }
    
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error> {
        return result.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
