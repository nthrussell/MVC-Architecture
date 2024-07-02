//
//  DetailViewController.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var name: String?
    private var detailView = DetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = name ?? ""
       
        self.view = detailView
        detailView.nameLabel.text = name
    }
}
