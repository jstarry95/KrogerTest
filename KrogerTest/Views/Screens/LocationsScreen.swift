//
//  ContentView.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/6/20.
//

import SwiftUI

struct LocationsScreen: View {
    
    @State private var searchText = ""
    
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
            Image(uiImage: #imageLiteral(resourceName: "kroger logo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                Spacer()
                    .frame(width: 24)
                Text("Find a store")
                    .font(.system(size: 32, weight: .bold, design: .default))
                Spacer()
            }
            Spacer()
                .frame(height: 16)
            HStack {
                Spacer()
                    .frame(width: 24)
                SearchBar(text: self.$searchText)
                Spacer()
                    .frame(width: 24)
            }
            Spacer()
                .frame(height: 12)
            Text("Results when you get them")
                .padding()
            Spacer()
        }
    }
}

struct LocationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LocationsScreen()
    }
}
