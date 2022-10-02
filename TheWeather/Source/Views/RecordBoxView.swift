//
//  WeatherView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

struct RecordBoxView: View {
    
    var recordImage: String
    var recordValue: String
    var recordTown: String
    
    var body: some View {
        VStack (){
            HStack (){
                Image(recordImage)
                    .frame(
                        minWidth: 50,
                        minHeight: 50,
                        alignment: .center
                    )
                Text(recordValue)
                    .foregroundColor(.white)
                    .frame(
                        minWidth: 50,
                        minHeight: 50,
                        alignment: .center
                    )
            }
            Text(recordTown)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 10))
        }
        .frame(
            minWidth: 150,
            minHeight: 150,
            alignment: .center
        )
    }
}

struct RecordBoxView_Previews: PreviewProvider {
    static var previews: some View {
        RecordBoxView(recordImage: "", recordValue: "", recordTown: "")
    }
}
