//
//  WeatherView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var myData: MyData
    
    var body: some View {
        VStack (alignment: .center){
            VStack (){
                HStack (){
                    RecordBoxView(recordImage: "Temp", recordValue: String(format: "%.1fºC", myData.hot_record), recordTown: myData.hot_record_town)
                    RecordBoxView(recordImage: "Humidity", recordValue: String(format: "%i%", myData.humidity_record), recordTown: myData.humidity_record_town)
                }
            }
            VStack (){
                HStack (){
                    RecordBoxView(recordImage: "Rain", recordValue: String(format: "%.2f", myData.rain_record), recordTown: myData.rain_record_town)
                    RecordBoxView(recordImage: "Wind", recordValue: String(format: "%.1f", myData.wind_record), recordTown: myData.wind_record_town)
                }
            }
        }
        .frame(
            maxWidth: .infinity
        )
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(myData: MyData())
    }
}
