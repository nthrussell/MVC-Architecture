//
//  FavouriteViewController.swift
//  MVC-Architecture
//
//  Created by russel on 11/7/24.
//

import UIKit
import CoreData

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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextObjectsDidChange),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: storageProvider.persistentContainer.viewContext)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllFavourites()
        deleteFavourite()
    }
    
    @objc func contextObjectsDidChange() {
        getAllFavourites()
    }
    
    private func getAllFavourites() {
        let allData = storageProvider.getAllData()
        let detailData = allData.map { PokemonDetailModel.mapFromEntity($0) }
        
        favouriteView.detailData = detailData
        favouriteView.tableView.reloadData()
    }
    
    private func deleteFavourite() {
        favouriteView.tapDelete = { [weak self] model in
            guard let self = self else { return }
            storageProvider.delete(name: model.name)
        }
    }
}
