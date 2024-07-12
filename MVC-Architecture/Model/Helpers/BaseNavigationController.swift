//
//  BaseNavigationCOntroller.swift
//  MVC-Architecture
//
//  Created by russel on 11/7/24.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.isTranslucent = false
    }
}
