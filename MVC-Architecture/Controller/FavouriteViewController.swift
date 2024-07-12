//
//  FavouriteViewController.swift
//  MVC-Architecture
//
//  Created by russel on 11/7/24.
//

import UIKit

class FavouriteViewController: UIViewController {

    private var favouriteView = FavouriteView()
    private var storageProvider: StorageProvider
    
    init(storageProvider: StorageProvider = StorageProvider()) {
        self.storageProvider = storageProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
        self.view = favouriteView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllFavourites()
    }
    
    func getAllFavourites() {
        let data = storageProvider.getAllData()
        let mappedData = data.map { PokemonDetailModel.mapFromEntity($0) }
        
        favouriteView.detailData = mappedData
        favouriteView.tableView.reloadData()
    }
}
