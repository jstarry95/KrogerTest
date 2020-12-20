//
//  Date+Extensions.swift
//  KrogerTest
//
//  Created by Matthew Lewandowski on 12/20/20.
//

import Foundation

extension Date {
    
    func day() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: self)
        return day
    }
    
    func dayName() -> String {
        
        let day = self.day()
        
        switch day {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func getHour() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        return hour
    }
}
