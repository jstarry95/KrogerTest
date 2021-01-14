//
//  ContentView.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/6/20.
//

import SwiftUI

struct LocationsScreen: View {
    
    @State private var searchText = ""
    @ObservedObject private var viewModel: LocationsViewModel = LocationsViewModel()
    
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
                Button(action: {
                    self.viewModel.search(zipCode: self.searchText)
                }, label: {
                    Text("Search")
                })
                Spacer()
                    .frame(width: 24)
            }
            Spacer()
                .frame(height: 12)
            if viewModel.results.isEmpty {
                Spacer()
                Text("No Results")
            } else {
                //add list of results
            }
            Spacer()
        }
    }
}

struct LocationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LocationsScreen()
    }
}
