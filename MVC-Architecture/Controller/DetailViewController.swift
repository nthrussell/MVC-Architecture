//
//  DetailViewController.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var url: String
    private var detailView = DetailView()
    private var detailApiService: DetailApiService
    private var storageProvider: StorageProvider
    var cancellable = Set<AnyCancellable>()
        
    init(url: String, 
         detailApiService: DetailApiService = DefaultDetailApiService(),
         storageProvider: StorageProvider = StorageProvider.shared
    ) {
        self.url = url
        self.detailApiService = detailApiService
        self.storageProvider = storageProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view = detailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        observeButtonTap()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.visibleViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    private func checkIfPokemonIsInFavouriteList(data: PokemonDetailModel) {
        let data = storageProvider.checkIfPokemonIsFavourite(data: data)
        print("checkIfPokemonIsInFavouriteList:\(data)")
        detailView.favouriteButton.isSelected = data ? true : false
    }
    
    func observeButtonTap() {
        detailView.onTap = { [weak self] data in
           guard let self = self else { return }
            print("button tapped")
            if storageProvider.checkIfPokemonIsFavourite(data: data) {
                storageProvider.delete(name: data.name)
                print("data deleted from favourite")
            } else {
                _ = data.mapToEntity(storageProvider.persistentContainer.viewContext)
                storageProvider.saveContext()
                print("data saved to favourite")
            }
        }
    }
    
    private func callApi() {
        showProgressSpinner()
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                print("status is:\(status)")
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                detailView.updateUI(data: data)
                checkIfPokemonIsInFavouriteList(data: data)
                hideProgressSpinner()
            }
            .store(in: &cancellable)
    }
}
