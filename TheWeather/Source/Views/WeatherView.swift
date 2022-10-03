//
//  WeatherView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

struct WeatherView: View {
    
    @EnvironmentObject var principalData: PrincipalDataModel
    
    var body: some View {
        VStack (alignment: .center){
            VStack (){
                HStack (){
                    RecordBoxView(recordImage: "Temp", recordValue: String(format: "%.1fºC", principalData.dataToPrint.hot_record), recordTown: principalData.dataToPrint.hot_record_town)
                    RecordBoxView(recordImage: "Humidity", recordValue: String(format: "%i%%", principalData.dataToPrint.humidity_record), recordTown: principalData.dataToPrint.humidity_record_town)
                }
            }
            VStack (){
                HStack (){
                    RecordBoxView(recordImage: "Rain", recordValue: String(format: "%.2fmm", principalData.dataToPrint.rain_record), recordTown: principalData.dataToPrint.rain_record_town)
                    RecordBoxView(recordImage: "Wind", recordValue: String(format: "%.1fkm/h", principalData.dataToPrint.wind_record), recordTown: principalData.dataToPrint.wind_record_town)
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
        WeatherView()
    }
}
