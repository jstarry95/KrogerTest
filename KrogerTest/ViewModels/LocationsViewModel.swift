//
//  LocationsViewModel.swift
//  KrogerTest
//
//  Created by Matthew Lewandowski on 1/14/21.
//

import Foundation

final class LocationsViewModel: ObservableObject {
    
    @Published var results: [Locations.Location] = []
    
    func search(zipCode: String?) {
        guard let unwrappedZip = zipCode else { return }
        
        let api = KrogerAPI(target: .locations(filters: ["filter.zipCode.near": "\(unwrappedZip)"]))
        KrogerNetworkManager.shared.makeRequest(to: api) { result in
            switch result {
            case .success(let data):
                guard let locations = try? JSONDecoder().decode(Locations.self, from: data) else { return }
                
                self.results = locations.data
            case .failure(let error):
                print("we done fucked up: \(error)")
            }
        }
    }
}
