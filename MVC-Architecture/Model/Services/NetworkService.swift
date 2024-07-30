//
//  NetworkService.swift
//  MVC-Architecture
//
//  Created by russel on 17/7/24.
//
import Foundation
import Combine

protocol NetworkService {
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError>
}

extension URLSession: NetworkService {
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        return dataTaskPublisher(for: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
