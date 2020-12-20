//
//  DefaultNetworkManager.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/8/20.
//

import Foundation

final class KrogerNetworkManager: NetworkManager {
    
    private let authCode = "YXBpdGVzdGFwcGxpY2F0aW9uLTRkMDRiNDY3YWVhZTg4MTJiMGVmZjI5MGFhYWFiMmVjMTAzNDk4Mjk1ODczNDYwMjM1MDpBVTdNdnZQTUNOd3Iya0RkQ2lJaUo5VnplVkJVRXVzRlJHSkg4eWtH"
    private var accessToken: String?
    
    enum HTTPStatusError: Error {
        case unauthorized
        case notFound
        case badRequest
        case other
    }
    
    enum HTTPError: Error {
        case generic
        case tokenFailure
        case invalidURL
    }
    
    static let shared = KrogerNetworkManager()
    private init() {}
    
    /**
     Makes a request to the designated API
     - parameter api: APITarget representing the API we would like to request from
     - parameter completion: NetworkManager.Completion to be called when the API returns a response
     */
    func makeRequest(to api: APITarget, completion: @escaping NetworkManager.Completion) {
        let baseURL = api.baseURL
        let path = api.path
        let body = api.body
        let successCode = api.successCode
        let headers = api.headers
        let requestType = api.requestType

        guard let fullURL = URL(string: baseURL.absoluteString + path) else {
            completion(.failure(HTTPError.invalidURL))
            return
        }
        
        var request = URLRequest(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval(60))
        
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        let urlComponents = self.getURLComponents(for: body)
        let bodyData = urlComponents?.query?.data(using: .utf8)
        request.httpBody = bodyData
        
        let method = self.getMethod(for: requestType)
        request.httpMethod = method
        
        self.performDataTask(for: request, successCode: successCode, completion: completion)
     }
    
    private func performDataTask(for request: URLRequest, successCode: Int, completion: @escaping NetworkManager.Completion) {
        
        var urlRequest = request
        if let token = self.accessToken {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let dataTask = self.getDataTask(for: urlRequest, successCode: successCode, completion: completion)
            dataTask.resume()
        } else {
            self.getAccessToken() { [weak self] token in
                guard let unwrappedToken = token,
                      let self = self else {
                    completion(.failure(HTTPError.tokenFailure))
                    return
                }
                
                self.accessToken = unwrappedToken
                urlRequest.addValue("Bearer \(unwrappedToken)", forHTTPHeaderField: "Authorization")
                let dataTask = self.getDataTask(for: urlRequest, successCode: successCode, completion: completion)
                dataTask.resume()
            }
        }
    }
    
    private func getAccessToken(completion: @escaping (String?) -> Void) {
        
        let authAPI = KrogerAPI(target: .auth(authCode: self.authCode))
        self.makeUnauthorizedRequest(to: authAPI) { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleAccessTokenSuccess(data: data, completion: completion)
            case .failure(let error):
                print("Access token error: \(error)")
                completion(nil)
            }
        }
    }
    
    private func handleAccessTokenSuccess(data: Data, completion: @escaping (String?) -> Void) {
        guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data),
              let token = authResponse.access_token else {
            completion(nil)
            return
        }
        
        completion(token)
    }
    
    private func makeUnauthorizedRequest(to api: APITarget, completion: @escaping NetworkManager.Completion) {
        let baseURL = api.baseURL
        let path = api.path
        let body = api.body
        let successCode = 200
        let headers = api.headers
        let requestType = api.requestType
        
        guard let fullURL = URL(string: baseURL.absoluteString + path) else {
            completion(.failure(HTTPError.invalidURL))
            return
        }
        
        var request = URLRequest(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval(60))
        
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        let urlComponents = self.getURLComponents(for: body)
        let bodyData = urlComponents?.query?.data(using: .utf8)
        request.httpBody = bodyData
        
        let method = self.getMethod(for: requestType)
        request.httpMethod = method
        
        let dataTask = self.getDataTask(for: request, successCode: successCode, completion: completion)
        dataTask.resume()
    }
    
    private func getDataTask(for request: URLRequest, successCode: Int, completion: @escaping NetworkManager.Completion) -> URLSessionTask {
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                completion(.failure(HTTPError.generic))
                return
            }
            
            if let responseError = error {
                completion(.failure(responseError))
            } else if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode != successCode {
                let statusError = self.getStatusError(for: httpResponse.statusCode)
                completion(.failure(statusError))
            } else if let responseData = data {
                completion(.success(responseData))
            } else {
                completion(.failure(HTTPError.generic))
            }
        }
        
        return dataTask
    }
    
    private func getURLComponents(for body: APIBody) -> URLComponents? {
        var urlComponents: URLComponents?
        switch body {
        case .none:
            break
        case .formData(let parameters):
            urlComponents = self.getURLComponents(from: parameters)
        case .urlEncoded(let parameters):
            urlComponents = self.getURLComponents(from: parameters)
        }
        
        return urlComponents
    }
    
    private func getURLComponents(from parameters: [String: Any]) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.queryItems = []
        
        parameters.keys.forEach { key in
            let value = parameters[key] as? String
            let queryItem = URLQueryItem(name: key, value: value)
            urlComponents.queryItems?.append(queryItem)
        }
        
        return urlComponents
    }
    
    private func getMethod(for type: APIRequestType) -> String {
        switch type {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
    
    private func getStatusError(for status: Int) -> HTTPStatusError {
        switch status {
        case 404:
            return .notFound
        case 400, 500, 501, 502, 503, 504:
            return .badRequest
        case 401:
            return .unauthorized
        default:
            return .other
        }
    }
}
