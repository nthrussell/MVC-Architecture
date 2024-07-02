//
//  HomeViewController.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Pokedex"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        self.view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        navigate()
    }
    
    func navigate() {
        homeView.onTap = { name in
            let vc = DetailViewController()
            vc.name = name
            self.show(vc, sender: self)
        }
    }
    
    func callApi() {
        fetchPokemonList { status in
            switch status {
            case .success(let payload):
                print("payload is:\(payload)")
                self.homeView.pokemonList = payload.results
                self.homeView.reloadTebleView()
            case .failure(let error):
                print("error:\(error)")
            }
        }
    }
    
   
}



extension HomeViewController {
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
