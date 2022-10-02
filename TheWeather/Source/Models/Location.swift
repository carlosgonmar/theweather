//
//  Location.swift
//  TheWeather
//
//  Created by Carlos González Martín on 2/10/22.
//

import MapKit
import Foundation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    var coordinate: CLLocationCoordinate2D
}
