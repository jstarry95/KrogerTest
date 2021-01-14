//
//  LocationResultViewModel.swift
//  KrogerTest
//
//  Created by Matthew Lewandowski on 12/20/20.
//

import Foundation

struct LocationResultViewModel {
    
    typealias Location = Locations.Location
    private let location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    func getName() -> String {
        return self.location.name ?? "Kroger"
    }
    
    func getAddress() -> String {
        let city = self.location.address?.city
        let state = self.location.address?.state
        let zipCode = self.location.address?.zipCode
        let address: String
        
        if let unwrappedCity = city, let unwrappedState = state, let unwrappedZip = zipCode {
            address = "\(unwrappedCity), \(unwrappedState) \(unwrappedZip)"
        } else if let unwrappedCity = city, let unwrappedState = state {
            address = "\(unwrappedCity), \(unwrappedState)"
        } else if let unwrappedCity = city {
            address = unwrappedCity
        } else {
            address = "N/A"
        }
        
        return address
    }
    
    func getIsOpen() -> Bool {
        
        guard let hours = self.getDayHours(),
              let openHours = hours.open,
              let closedHours = hours.closed else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:"
        
        guard let openTime = dateFormatter.date(from: openHours),
              let closedTime = dateFormatter.date(from: closedHours) else { return false }
        
        let currentHour = Date().getHour()
        
        if currentHour >= openTime.getHour(),
           currentHour < closedTime.getHour() {
            return true
        } else {
            return false
        }
    }
    
    private func getDayHours() -> Locations.DayHours? {
        
        let day = Date().day()
        
        switch day {
        case 1:
            return self.location.hours?.sunday
        case 2:
            return self.location.hours?.monday
        case 3:
            return self.location.hours?.tuesday
        case 4:
            return self.location.hours?.wednesday
        case 5:
            return self.location.hours?.thursday
        case 6:
            return self.location.hours?.friday
        case 7:
            return self.location.hours?.saturday
        default:
            return nil
        }
    }
}
