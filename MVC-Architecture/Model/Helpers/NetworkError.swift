//
//  NetworkError.swift
//  MVC-Architecture
//
//  Created by russel on 2/7/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case invalidResponse
    case unknown
}
