//
//  KrogerAPI.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/8/20.
//

import UIKit

struct KrogerAPI: APITarget {

    enum Target {
        case auth(authCode: String)
        case products(filters: [String: String])
        case locations(filters: [String: String])
    }
        
    let target: Target
    
    var baseURL: URL {
        return URL(string: "https://api-ce.kroger.com")!
    }
    
    var path: String {
        switch self.target {
        case .auth:
            return "/v1/connect/oauth2/token"
        case .locations(let filters):
            return "/v1/locations" + self.getFilterString(from: filters)
        case .products(let filters):
            return "/v1/products" + self.getFilterString(from: filters)
        }
    }
    
    var body: APIBody{
        switch self.target {
        case .auth:
            let parameters = [
                "grant_type": "client_credentials",
                "scope": "product.compact"
            ]
            
            return .urlEncoded(parameters: parameters)
            
        default:
            return .none
        }
    }
    
    var headers: [String: String] {
        switch self.target {
        case .auth(let authCode):
            return [
                "Authorization": "Basic \(authCode)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .locations:
            return [:]
        case .products:
            return [:]
        }
    }
    
    var requestType: APIRequestType {
        switch self.target {
        case .auth:
            return .post
        default:
            return .get
        }
    }
    
    private func getFilterString(from filters: [String: String]) -> String {
        var filterString = ""
        
        for (filter, value) in filters {
            let newFilter = "\(filter)=\(value)"
            let formattedFilter: String
            
            if filterString.isEmpty {
                formattedFilter = String("?\(newFilter)")
            } else {
                formattedFilter = String("&\(newFilter)")
            }
            filterString.append(formattedFilter)
        }
        
        return filterString
    }
}
