//
//  DownloadImageService.swift
//  MVC-Architecture
//
//  Created by russel on 4/7/24.
//
import Kingfisher
import UIKit

protocol DownloadImageService {
    func downloadImage(with imageView: UIImageView, from url: String) -> DownloadTask?
}

class DefaultDownloadImageService: DownloadImageService {
    func downloadImage(with imageView: UIImageView, from url: String) -> Kingfisher.DownloadTask? {
        let url = URL(string: url)
        return imageView.kf.setImage(with: url)
    }
}
