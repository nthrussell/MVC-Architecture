//
//  HomeApiService.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import Foundation
import Combine


protocol HomeApiService {
    init(networkService: NetworkService)
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error>
}

class DefaultHomeApiService: HomeApiService {
    let networkService: NetworkService

    required init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        var url = URL(string: Constant.URL.baseURL + "/pokemon")!
        url.append(queryItems: [URLQueryItem(name: "limit", value: "\(20)"),
                               URLQueryItem(name: "offset", value: "\(offset)")])
        
        return networkService.load(URLRequest(url: url))
            .decode(type: PokemonListModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}
