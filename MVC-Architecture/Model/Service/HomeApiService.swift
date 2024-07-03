//
//  HomeApiService.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import Foundation
import Combine

protocol HomeApiService {
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error>
}

class DefaultHomeApiService: HomeApiService {
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        var url = URL(string: Constant.URL.baseURL + "/pokemon")!
        url.append(queryItems: [URLQueryItem(name: "limit", value: "\(20)"),
                               URLQueryItem(name: "offset", value: "\(offset)")])
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response in
                return try JSONDecoder().decode(PokemonListModel.self, from: response.data)
            }
            .mapError({ error in
                switch error {
                case is URLError:
                    return NetworkError.badURL
                case is DecodingError:
                    return NetworkError.decodingError
                default:
                    return NetworkError.unknown
                }
            })
            .eraseToAnyPublisher()
    }
}
