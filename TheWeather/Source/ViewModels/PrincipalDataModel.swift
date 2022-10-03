//
//  PrincipalDataModel.swift
//  TheWeather
//
//  Created by Carlos González Martín on 2/10/22.
//

import MapKit
import Foundation
import SwiftUI

class PrincipalDataModel: ObservableObject {
    
    // Values required to print the app
    var dataToPrint: DataToPrint = DataToPrint()
    
    // All locatons
    var locations: [Location]
    // Current locations
    var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let initialLatitudinalMetres: Double = 700000
    let initialLongitudinalMetres: Double = 700000
    
    init() {
        let locations = [
            Location(name: "Madrid", coordinate: CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: -3.6870897507878024))
        ]
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: self.mapLocation)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres)
            
        }
    }
    
    func showCurrentLocation() {
        withAnimation(.easeInOut) {
            mapLocation = Location(name: dataToPrint.town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.latitude, longitude: dataToPrint.longitude))
        }
    }
    
    public func valuesAssignaments(currentData: DataToPrint){
        
        let term = dataToPrint.term
        let country = dataToPrint.country
        dataToPrint = currentData
        dataToPrint.term = term
        dataToPrint.country = country
        locations = [
            Location(name: dataToPrint.town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.latitude, longitude: dataToPrint.longitude)),
            Location(name: dataToPrint.north_town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.north_latitude, longitude: dataToPrint.north_longitude)),
            Location(name: dataToPrint.south_town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.south_latitude, longitude: dataToPrint.south_longitude)),
            Location(name: dataToPrint.east_town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.east_latitude, longitude: dataToPrint.east_longitude)),
            Location(name: dataToPrint.west_town, coordinate: CLLocationCoordinate2D(latitude: dataToPrint.west_latitude, longitude: dataToPrint.west_longitude)),
        ]
        showCurrentLocation()
        
    }
    
}
