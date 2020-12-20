//
//  NetworkManager.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/10/20.
//

import Foundation

protocol NetworkManager {
    typealias Completion = (Result<Data, Error>) -> Void
    func makeRequest(to api: APITarget, completion: @escaping Completion)
}
