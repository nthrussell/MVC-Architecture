//
//  UIImageView+Extension.swift
//  MVC-Architecture
//
//  Created by russel on 4/7/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func getImage(from url: URL) {
        kf.setImage(with: url)
    }
}
