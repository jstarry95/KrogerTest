//
//  Locations.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/7/20.
//

import Foundation

struct Locations: Codable {
    let data: [Location]
    
    struct Location: Codable {
        let locationId: String?
        let chain: String?
        let name: String?
        let address: Address?
        let geoLocation: GeoLocation?
        let departments: [Department]?
    }
    
    struct Address: Codable {
        let addressLine1: String?
        let city: String?
        let state: String?
        let zipCode: String?
    }
    
    struct GeoLocation: Codable {
        let latitude: Double?
        let longitude: Double?
        let latLng: String?
    }
    
    struct Department: Codable {
        let departmentId: String?
        let name: String?
    }
}
