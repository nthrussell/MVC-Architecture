//
//  NetworkService.swift
//  MVC-Architecture
//
//  Created by russel on 17/7/24.
//
import Combine
import Foundation

protocol NetworkService {
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError>
}
