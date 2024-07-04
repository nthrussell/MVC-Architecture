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
    var cancellable = Set<AnyCancellable>()
    
    init(url: String, detailApiService: DetailApiService = DefaultDetailApiService()) {
        self.url = url
        self.detailApiService = detailApiService
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
    }
    
    private func callApi() {
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                print("status is:\(status)")
            } receiveValue: { [weak self] data in
                print("detail data is:\(data)")
                guard let self = self else { return }
                detailView.updateUI(data: data)
                downloadImage(with: data.sprites.frontDefault)
            }
            .store(in: &cancellable)
    }
    
    private func downloadImage(with url:String) {
        detailApiService
            .downloadImage(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                print("image download status is:\(status)")
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                print("image data is:\(data)")
                guard let convertedImage = UIImage(data: data) else { return }
                detailView.updateImage(image: convertedImage)
            }
            .store(in: &cancellable)
    }
}
