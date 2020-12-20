//
//  APITarget.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/8/20.
//

import Foundation

enum APIBody {
    case none
    case urlEncoded(parameters: [String: Any])
    case formData(parameters: [String: Any])
}

enum APIRequestType {
    case get
    case post
    case put
    case delete
}

protocol APITarget {
    var baseURL: URL { get }
    var path: String { get }
    var body: APIBody{ get }
    var successCode: Int { get }
    var headers: [String: String] { get }
    var requestType: APIRequestType { get }
}

extension APITarget {
    var successCode: Int {
        return 200
    }
}
