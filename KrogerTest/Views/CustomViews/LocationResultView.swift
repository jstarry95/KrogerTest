//
//  LocationResultView.swift
//  KrogerTest
//
//  Created by Matthew Lewandowski on 12/20/20.
//

import SwiftUI

struct LocationResultView: View {
    
    typealias Location = Locations.Location
    private let viewModel: LocationResultViewModel
    
    init(location: Location) {
        self.viewModel = LocationResultViewModel(location: location)
    }
    
    var body: some View {
        
        let name = self.viewModel.getName()
        let isOpen = self.viewModel.getIsOpen()
        let address = self.viewModel.getAddress()
        
        VStack {
            HStack {
                Spacer()
                    .frame(width: 16)
                Text(name)
                    .font(.system(size: 24))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            Spacer()
                .frame(height: 8)
            HStack {
                Spacer()
                    .frame(width: 16)
                Text(address)
                Spacer()
                Text(isOpen ? "Open" : "Closed")
                Spacer()
                    .frame(width: 24)
            }
        }
    }
}

struct LocationResultView_Previews: PreviewProvider {
    
    typealias Location = Locations.Location
    
    static var previews: some View {
        
        let previewAddress = Locations.Address(addressLine1: "453 Main Street", city: "Atlanta", state: "GA", zipCode: "98435")
        
        // TODO: set real hours
        let previewHours = Locations.Hours(timezone: "America/Chicago", open24: true, monday: nil, tuesday: nil, wednesday: nil, thursday: nil, friday: nil, saturday: nil, sunday: nil)
        
        // TODO: add GeoLocation, phone
        let previewLocation: Location  = Location(locationId: "6969", chain: "Kroger", name: "Kroger", address: previewAddress, geoLocation: nil, departments: nil, hours: previewHours, phone: nil)
        
        LocationResultView(location: previewLocation)
    }
}
