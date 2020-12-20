//
//  ContentView.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/6/20.
//

import SwiftUI

struct LocationsScreen: View {
    
    init() {
        let api = KrogerAPI(target: .locations(filters: ["filter.zipCode.near": "75056"]))
        KrogerNetworkManager.shared.makeRequest(to: api) { result in
            switch result {
            case .success(let data):
                print("we done did it")
            case .failure(let error):
                print("we done fucked up: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            Text("KrogerLogo")
                .padding()
            Spacer()
                .frame(height: 32)
            Text("Find a store")
                .padding()
            Spacer()
                .frame(height: 8)
            Text("Search bar")
                .padding()
            Spacer()
                .frame(height: 12)
            Text("Results when you get them")
                .padding()
        }
    }
}

struct LocationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LocationsScreen()
    }
}
