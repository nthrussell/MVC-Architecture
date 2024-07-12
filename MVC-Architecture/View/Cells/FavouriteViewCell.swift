//
//  FavouriteViewCell.swift
//  MVC-Architecture
//
//  Created by russel on 12/7/24.
//

import UIKit

class FavouriteViewCell: UITableViewCell {
    static let identifier = "\(FavouriteViewCell.self)"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
