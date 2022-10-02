//
//  ContentView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

class MyData: ObservableObject {
    
    @Published var term: String = "Luxemburgo"
    @Published var town: String = "Badajoz"
    @Published var country: String = "LU"
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var weather: String = "Clouds"
    @Published var description: String = "overcast clouds"
    @Published var icon: String = "04n"
    @Published var north_town: String = "Badajoz"
    @Published var south_town: String = "Badajoz"
    @Published var east_town: String = "Badajoz"
    @Published var west_town: String = "Badajoz"
    @Published var hot_record: Float = 25.0
    @Published var hot_record_town: String = "Badajoz, ES"
    @Published var humidity_record: Int = 16
    @Published var humidity_record_town: String = "Badajoz, ES"
    @Published var rain_record: Float = 5
    @Published var rain_record_town: String = "Badajoz, ES"
    @Published var wind_record: Float = 23
    @Published var wind_record_town: String = "Badajoz, ES"
    
}

struct ContentView: View {
    
    
    @State var showAlertSheet: Bool = false
    @EnvironmentObject var errorHandling: ErrorHandling
    @StateObject private var myData = MyData()
    
    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
            CurrentBoxView(myData: myData)
            Spacer()
            SearchView(myData: myData, showAlertSheet: $showAlertSheet)
            WeatherView(myData: myData)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        )
        .background(Color(red: 121/255, green: 104/255, blue: 134/255))
        .alert(isPresented: $showAlertSheet, content: {
                    return Alert(title: Text("No Internet Connection"), message: Text("Please enable Wifi or Celluar data"), dismissButton: .default(Text("Cancel")))
                })

    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
