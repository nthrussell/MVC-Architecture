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
        homeApiService.fetchPokemonList { status in
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
