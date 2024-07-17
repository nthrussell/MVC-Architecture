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
    private var detailStorageService: DetailStorageService
    var cancellable = Set<AnyCancellable>()
        
    init(url: String, 
         detailApiService: DetailApiService = DefaultDetailApiService(),
         detailStorageService: DetailStorageService = DefaultDetailStorageService(storageProvider: StorageProvider.shared)
    ) {
        self.url = url
        self.detailApiService = detailApiService
        self.detailStorageService = detailStorageService
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
        let data = detailStorageService.checkIfFavourite(data: data)
        detailView.favouriteButton.isSelected = data ? true : false
    }
    
    private func observeButtonTap() {
        detailView.onTap = { [weak self] data in
           guard let self = self else { return }
            detailStorageService.saveOrDelete(with: data)
        }
    }
    
    private func callApi() {
        showProgressSpinner()
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                detailView.updateUI(data: data)
                checkIfPokemonIsInFavouriteList(data: data)
                hideProgressSpinner()
            }
            .store(in: &cancellable)
    }
}
