//
//  DetailViewController.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var url: String?
    private var detailView = DetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.view = detailView
    }
}
