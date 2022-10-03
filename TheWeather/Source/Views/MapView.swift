//
//  MapView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 2/10/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var principalData: PrincipalDataModel
    
    var body: some View {
        Map(coordinateRegion: $principalData.mapRegion,
            annotationItems: principalData.locations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(location.name) {
                        principalData.getWeatherFromGeolocation(location: location)
                    }
                    .padding(5)
                    .background(Color(red: 121/255, green: 104/255, blue: 134/255))
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .font(.system(size: 10))
                }
            }
        )
        .frame(
            maxHeight: .infinity
        )
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
