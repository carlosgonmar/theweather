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
                LocationMapAnnotationView(name: location.name)
            }
        }
        )
            .ignoresSafeArea()
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
