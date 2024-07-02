//
//  HomeApiService.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import Foundation

protocol HomeApiService {
    func fetchPokemonList(completion: @escaping (Result<PokemonListModel, NetworkError>) -> Void)
}

class DefaultHomeApiService: HomeApiService {
    func fetchPokemonList(completion: @escaping (Result<PokemonListModel, NetworkError>) -> Void) {
        
        guard let url = URL(string: Constant.URL.baseURL + "/pokemon") else {
            completion(.failure(.decodingError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.badURL))
                return
            }
            
            guard let response  = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                do {
                    let pokeData = try JSONDecoder().decode(PokemonListModel.self, from: data)
                    completion(.success(pokeData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }

}
