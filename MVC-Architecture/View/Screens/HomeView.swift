//
//  HomeView.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit

class HomeView: UIView {
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
    
    private(set) lazy var activityindicatorView:UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: .medium)
        aiView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45)
        aiView.translatesAutoresizingMaskIntoConstraints = true
        return aiView
    }()
    
    var fetchMoreData: (() -> Void)?
    var onTap: ((_ url:String) -> Void)?

    var pokemonList: [PokemonList] = [PokemonList]()
    private(set) var filteredData: [PokemonList] = [PokemonList]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(searchBar)
        addSubview(tableView)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func isFiltering() -> Bool {
        return filteredData.count > 0
    }
    
    func reloadTebleView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeView: UITableViewDataSource {
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
            activityindicatorView.stopAnimating()
        } else {
            data = pokemonList[indexPath.row]
        }
        
        if (indexPath.row == pokemonList.count - 1) && (!isFiltering()){
            tableView.tableFooterView = activityindicatorView
            activityindicatorView.startAnimating()
            if let fetchMoreData = fetchMoreData { fetchMoreData() }
        }
        
        cell.nameLabel.text = data.name
        
        return cell
    }
}

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: PokemonList
        
        if isFiltering() {
            data = filteredData[indexPath.row]
        } else {
            data = pokemonList[indexPath.row]
        }

        if let onTap = onTap {
            onTap(data.url)
        }
    }
}

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        filteredData = pokemonList.filter {
            $0.name.lowercased().contains(textSearched.lowercased().trimmingCharacters(in: .whitespaces))
        }
        reloadTebleView()
    }
}
