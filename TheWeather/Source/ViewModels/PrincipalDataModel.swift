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
    
    @Published var term: String = "Madrid"
    @Published var town: String = "Madrid"
    @Published var country: String = "ES"
    @Published var latitude: Double = 40.41835349621259
    @Published var longitude: Double = -3.6870897507878024
    @Published var weather: String = "Clouds"
    @Published var description: String = "overcast clouds"
    @Published var icon: String = "04n"
    @Published var north_town: String = ""
    @Published var north_latitude: Double = 0
    @Published var north_longitude: Double = 0
    @Published var south_town: String = ""
    @Published var south_latitude: Double = 0
    @Published var south_longitude: Double = 0
    @Published var east_town: String = ""
    @Published var east_latitude: Double = 0
    @Published var east_longitude: Double = 0
    @Published var west_town: String = ""
    @Published var west_latitude: Double = 0
    @Published var west_longitude: Double = 0
    @Published var hot_record: Float = 5
    @Published var hot_record_town: String = ""
    @Published var humidity_record: Int = 0
    @Published var humidity_record_town: String = ""
    @Published var rain_record: Float = 0
    @Published var rain_record_town: String = ""
    @Published var wind_record: Float = 0
    @Published var wind_record_town: String = ""
    
    @EnvironmentObject var errorHandling: ErrorHandling
    // All locatons
    @Published var locations: [Location]
    // Current locations
    @Published var mapLocation: Location {
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
    
    public func getWeatherFromGeolocation(location: Location) {
        
        OpenWeatherMapProvider.shared.getCurrentWeatherDataFromCoordinates(town: location.name, myCoordinates: Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { currentData in
            
            self.valuesAssignaments(currentData: currentData)
            self.fillLocations()
            self.showCurrentLocation()

        } failure: { error in
            
            debugPrint(error)
            self.errorHandling.handle(error: error)
            
        }
        
    }
    
    func showCurrentLocation() {
        withAnimation(.easeInOut) {
            mapLocation = Location(name: town, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    public func getWeatherFromString() {
        
        OpenWeatherMapProvider.shared.getCurrentWeatherData(term: term, country: country) { currentData in
            
            self.valuesAssignaments(currentData: currentData)
            self.fillLocations()
            self.showCurrentLocation()

        } failure: { error in
            
            debugPrint(error)
            self.errorHandling.handle(error: error)
            
        }
        
    }
    
    private func fillLocations(){
     
        
        locations = [
            Location(name: town, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)),
            Location(name: north_town, coordinate: CLLocationCoordinate2D(latitude: north_latitude, longitude: north_longitude)),
            Location(name: south_town, coordinate: CLLocationCoordinate2D(latitude: south_latitude, longitude: south_longitude)),
            Location(name: east_town, coordinate: CLLocationCoordinate2D(latitude: east_latitude, longitude: east_longitude)),
            Location(name: west_town, coordinate: CLLocationCoordinate2D(latitude: west_latitude, longitude: west_longitude)),
        ]
        
    }
    
    private func valuesAssignaments(currentData: Current){
        
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
        east_latitude = currentData.east_latitude
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
        
    }
    
}
