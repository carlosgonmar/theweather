//
//  SearchView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var errorHandling: ErrorHandling
    @ObservedObject var myData: MyData
    
    var body: some View {
        
        HStack {
            TextField("Search your city", text: $myData.term)
                    .keyboardType(.webSearch)
                    .disableAutocorrection(true)
                    .padding(5)
                    .font(.headline)
                    .foregroundColor(.white)
                    .ignoresSafeArea(.keyboard)
                    .onSubmit {
                        
                        if myData.term.count >= 1 {
                            
                            OpenWeatherMapProvider.shared.getCurrentWeatherData(term: myData.term, country: myData.country) { currentData in
                                
                                myData.town = currentData.town
                                myData.latitude = currentData.latitude
                                myData.longitude = currentData.longitude
                                myData.weather = currentData.weather
                                myData.description = currentData.description
                                myData.icon = currentData.icon
                                myData.hot_record = currentData.hot_record
                                myData.hot_record_town = currentData.hot_record_town
                                myData.humidity_record = currentData.humidity_record
                                myData.humidity_record_town = currentData.humidity_record_town
                                myData.rain_record = currentData.rain_record
                                myData.rain_record_town = currentData.rain_record_town
                                myData.wind_record = currentData.wind_record
                                myData.wind_record_town = currentData.wind_record_town
                                
                            } failure: { error in
                                
                                errorHandling.handle(error: error)
                                
                            }
                        }
                }
            CountryView(myData: myData)
        }
        .background(Color.white.opacity(0.3))
        .cornerRadius(6)
        .padding(.horizontal, 20)
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(myData: MyData())
    }
}
