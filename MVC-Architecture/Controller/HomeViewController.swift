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
    private var homeApiService: HomeApiService
    var cancellable = Set<AnyCancellable>()
    
    init(homeApiService: HomeApiService = DefaultHomeApiService()) {
        self.homeApiService = homeApiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Pokedex"
        navigationController?.setUpNavigation()
        
        self.view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        fetchMoreData()
        navigate()
    }
    
    func navigate() {
        homeView.onTap = { url in
            let vc = DetailViewController(url: url)
            self.show(vc, sender: self)
        }
    }
    
    func fetchMoreData() {
        homeView.fetchMoreData = {
            self.callApi()
        }
    }
    
    func callApi() {
        homeApiService.fetchPokemonList(offset: homeView.pokemonList.count)
            .sink { status in
                print("status is:\(status)")
            } receiveValue: { [weak self] payload in
                guard let self = self else { return }
                print("payload is:\(payload)")
                self.homeView.pokemonList.append(contentsOf: payload.results)
                self.homeView.reloadTebleView()
            }
            .store(in: &cancellable)
    }
}
