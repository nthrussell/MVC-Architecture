//
//  DetailApiService.swift
//  MVC-Architecture
//
//  Created by russel on 3/7/24.
//

import Foundation
import Combine

protocol DetailApiService {
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error>
    func downloadImage(with url:String) -> AnyPublisher<Data, Never>
}

class DefaultDetailApiService: DetailApiService {
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error> {
        let url = URL(string: url)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetailModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func downloadImage(with url:String) -> AnyPublisher<Data, Never> {
        let imageUrl = URL(string: url)!

        return URLSession.shared.dataTaskPublisher(for: imageUrl)
            .map(\.data)
            .replaceError(with: Data())
            .eraseToAnyPublisher()
    }
}
