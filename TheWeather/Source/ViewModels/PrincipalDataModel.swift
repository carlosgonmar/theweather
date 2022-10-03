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
    var term: String = ""
    var town: String = "Madrid"
    var country: String = "ES"
    var latitude: Double = 40.41835349621259
    var longitude: Double = -3.6870897507878024
    var weather: String = "Clouds"
    var description: String = "overcast clouds"
    var icon: String = "04n"
    var north_town: String = ""
    var north_latitude: Double = 0
    var north_longitude: Double = 0
    var south_town: String = ""
    var south_latitude: Double = 0
    var south_longitude: Double = 0
    var east_town: String = ""
    var east_latitude: Double = 0
    var east_longitude: Double = 0
    var west_town: String = ""
    var west_latitude: Double = 0
    var west_longitude: Double = 0
    var hot_record: Float = 0
    var hot_record_town: String = ""
    var humidity_record: Int = 0
    var humidity_record_town: String = ""
    var rain_record: Float = 0
    var rain_record_town: String = ""
    var wind_record: Float = 0
    var wind_record_town: String = ""
    
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
            mapLocation = Location(name: town, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    public func valuesAssignaments(currentData: Current){
        
        town = currentData.town
        latitude = currentData.latitude
        longitude = currentData.longitude
        weather = currentData.weather
        description = currentData.description
        north_town = currentData.north_town
        north_latitude = currentData.north_latitude
        north_longitude = currentData.north_longitude
        south_town = currentData.south_town
        south_latitude = currentData.south_latitude
        south_longitude = currentData.south_longitude
        east_town = currentData.east_town
        east_latitude = currentData.east_latitude
        east_longitude = currentData.east_longitude
        west_town = currentData.west_town
        west_latitude = currentData.west_latitude
        west_longitude = currentData.west_longitude
        hot_record = currentData.hot_record
        hot_record_town = currentData.hot_record_town
        humidity_record = currentData.humidity_record
        humidity_record_town = currentData.humidity_record_town
        rain_record = currentData.rain_record
        rain_record_town = currentData.rain_record_town
        wind_record = currentData.wind_record
        wind_record_town = currentData.wind_record_town
        locations = [
            Location(name: town, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)),
            Location(name: north_town, coordinate: CLLocationCoordinate2D(latitude: north_latitude, longitude: north_longitude)),
            Location(name: south_town, coordinate: CLLocationCoordinate2D(latitude: south_latitude, longitude: south_longitude)),
            Location(name: east_town, coordinate: CLLocationCoordinate2D(latitude: east_latitude, longitude: east_longitude)),
            Location(name: west_town, coordinate: CLLocationCoordinate2D(latitude: west_latitude, longitude: west_longitude)),
        ]
        debugPrint(locations)
        showCurrentLocation()
        /*
         
         [
         TheWeather.Location(id: E00D896A-5ED8-48DC-8B96-746D587A9BA1, name: "Madrid", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: -3.6870897507878024)),
         TheWeather.Location(id: A46CA1DE-2CDF-48EB-8534-7237692B80A0, name: "Cogollos, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 42.214984064451635, longitude: -3.6870897507878024)),
         TheWeather.Location(id: 754DE56C-9A61-4B1C-8D46-E7D1548D506A, name: "Calzada de Calatrava, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 38.62172292797354, longitude: -3.6870897507878024)),
         TheWeather.Location(id: 4928FF03-9AAC-4475-B01E-EBA8CF087AB4, name: "Gea de Albarracín, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: 0.0)),
         TheWeather.Location(id: 4454C1DB-9D29-49A4-80C0-AB314CD966A8, name: "Herguijuela de la Sierra, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: -6.046945553169258))]
         
         [TheWeather.Location(id: 59BFCA52-36A8-4D2E-93F2-C489404CD51A, name: "Herguijuela de la Sierra, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: -6.046945553169258)),
         TheWeather.Location(id: CB6CB4AB-1FDD-4C82-B661-4C5AA0C9457E, name: "Castrocalbón, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 42.214984064451635, longitude: -6.046945553169258)),
         TheWeather.Location(id: DAB9B57E-F27E-4B97-80D6-14CDAC534EEC, name: "Hornachos, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 38.62172292797354, longitude: -6.046945553169258)),
         TheWeather.Location(id: 1992EDC1-0B80-47FD-904E-644D3E9C0C6D, name: "Madrid, ES", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: 0.0)),
         TheWeather.Location(id: 56AC2426-F1FD-4E7C-A555-F41853D2ED25, name: "Anadia, PT", coordinate: __C.CLLocationCoordinate2D(latitude: 40.41835349621259, longitude: -8.406801355550714))]
         
         
         */
        
    }
    
}
