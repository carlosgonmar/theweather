//
//  MapView.swift
//  TheWeather
//
//  Created by Carlos González Martín on 2/10/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var errorHandling: ErrorHandling
    @EnvironmentObject private var principalData: PrincipalDataModel
    @State var mapRegion:MKCoordinateRegion?
    
    var body: some View {
            Map(coordinateRegion: $principalData.mapRegion,
                annotationItems: $principalData.locations.wrappedValue,
                annotationContent: { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Button {
                            OpenWeatherMapProvider.shared.getCurrentWeatherDataFromCoordinates(town: location.name, myCoordinates: Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { currentData in
                                
                                self.principalData.valuesAssignaments(currentData: currentData)

                            } failure: { error in
                                
                                self.errorHandling.handle(error: error)
                                
                            }
                        } label: {
                            Text("\(location.name)")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                    .font(.system(size: 8))
                                    .lineLimit(5, reservesSpace:false)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(
                                        minWidth: 40,
                                        maxWidth: 60
                                    )
                        }
                        .padding(5)
                        .background(Color(red: 121/255, green: 104/255, blue: 134/255))
                        .cornerRadius(5)
                    }
                }
            )
            .ignoresSafeArea()
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
