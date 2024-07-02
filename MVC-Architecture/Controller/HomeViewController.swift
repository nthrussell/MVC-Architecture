//
//  HomeViewController.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private(set) var pokemonList: [PokemonList] = [PokemonList]()
    private(set) var filteredData: [PokemonList] = [PokemonList]()
    
    private(set) lazy var searchBar:UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.searchBarStyle = .default
        searchbar.delegate = self
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private(set) lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: HomeViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var onTap: ((_ name:String) -> Void)?
    
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

        view.addSubview(searchBar)
        view.addSubview(tableView)
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        navigate()
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func navigate() {
        onTap = { name in
            let vc = DetailViewController()
            vc.name = name
            self.show(vc, sender: self)
        }
    }
    
    private func reloadTebleView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func callApi() {
        fetchPokemonList { status in
            switch status {
            case .success(let payload):
                print("payload is:\(payload)")
                self.pokemonList = payload.results
                self.reloadTebleView()
            case .failure(let error):
                print("error:\(error)")
            }
        }
    }
    
    func isFiltering() -> Bool {
        return filteredData.count > 0
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredData.count
        } else {
            return pokemonList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeViewCell.identifier,
            for: indexPath
        ) as! HomeViewCell
        
        var data: PokemonList
        if isFiltering() {
            data = filteredData[indexPath.row]
        } else {
            data = pokemonList[indexPath.row]
        }
        
        cell.nameLabel.text = data.name
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = pokemonList[indexPath.row]
        onTap?(data.name)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        filteredData = pokemonList.filter {
            $0.name.lowercased().contains(textSearched.lowercased().trimmingCharacters(in: .whitespaces))
        }
        reloadTebleView()
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
