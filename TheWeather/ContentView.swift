//
//  ContentView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    
    @State var showAlertSheet: Bool = false
    @State var latitude: Double = 40.41835349621259
    @State var longitude: Double = -3.6870897507878024
    @EnvironmentObject var errorHandling: ErrorHandling
    @StateObject var principalData = PrincipalDataModel()
    
    var body: some View {
        
        VStack(alignment: .center) {
            MapView()
            Spacer()
            SearchView(showAlertSheet: $showAlertSheet)
            WeatherView()
        }
        .background(Color(red: 121/255, green: 104/255, blue: 134/255))
        .ignoresSafeArea()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        )
        .alert(isPresented: $showAlertSheet, content: {
                    return Alert(title: Text("No Internet Connection"), message: Text("Please enable Wifi or Celluar data"), dismissButton: .default(Text("Cancel")))
                })
        .environmentObject(principalData)
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
