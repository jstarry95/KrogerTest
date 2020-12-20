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
        let hours: Hours?
        let phone: String?
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

    struct Hours: Codable {
        let timezone: String?
        let open24: Bool?
        let monday: DayHours?
        let tuesday: DayHours?
        let wednesday: DayHours?
        let thursday: DayHours?
        let friday: DayHours?
        let saturday: DayHours?
        let sunday: DayHours?
    }
    
    struct DayHours: Codable {
        let open: String?
        let closed: String?
        let open24: Bool?
    }
}
