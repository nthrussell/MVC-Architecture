//
//  DetailApiService.swift
//  MVC-Architecture
//
//  Created by russel on 3/7/24.
//

import Foundation
import Combine

protocol DetailApiService {
    init(networkService: NetworkService)
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error>
}

class DefaultDetailApiService: DetailApiService {
    
    let networkService: NetworkService

    required init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error> {
        let url = URL(string: url)!
        
        return networkService.load(URLRequest(url: url))
            .decode(type: PokemonDetailModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
