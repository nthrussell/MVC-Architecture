//
//  UINavigationController_Extension.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//
import UIKit

extension UINavigationController {
    func setUpNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
    }
}
