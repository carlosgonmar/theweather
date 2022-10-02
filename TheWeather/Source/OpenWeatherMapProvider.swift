//
//  OpenWeatherMapProvider.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import Foundation
import Alamofire

enum Positions: String, CaseIterable {
    case North = "N"
    case South = "S"
    case East = "E"
    case West = "W"
}

struct Coordinates {
    var latitude: Double = 0
    var longitude: Double = 0
}


final class OpenWeatherMapProvider {
    
    static let shared = OpenWeatherMapProvider()
    private let kBaseUrl = "https://api.openweathermap.org"
    private var kAccesToken = "asd"
    private let kUnits = "metric"
    private let kEarthRKm: Double = 6378.137
    private let kDefaultDistanceKm: Double = 200
    
    func getCurrentWeatherData(term: String, country: String, success: @escaping (_ currentData: Current) -> (), failure: @escaping (_ error: Error) -> ()) {
        
        kAccesToken = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherMapToken") as? String ?? ""
        
        var currentData: Current = Current()
        getGeopoint(term: term, country: country) { place in
            
            let myCoordinates = Coordinates(latitude: place.lat, longitude: place.lon)
            
            currentData.town = place.name
            currentData.latitude = myCoordinates.latitude
            currentData.longitude = myCoordinates.longitude
            
            // Get initial town measures
            self.getWeather(coordinates: myCoordinates) { weather in
                
                currentData.weather = weather.current.weather.first!.main
                currentData.description = weather.current.weather.first!.description
                currentData.icon = weather.current.weather.first!.icon
                currentData.hot_record = weather.current.temp
                currentData.hot_record_town = currentData.town
                currentData.humidity_record = weather.current.humidity
                currentData.humidity_record_town = currentData.town
                currentData.rain_record = weather.current.rain!.inLastHour
                currentData.rain_record_town = currentData.town
                currentData.wind_record = weather.current.wind_speed
                currentData.wind_record_town = currentData.town
                success(currentData)
                // Get 4 close towns
                for position in Positions.allCases {
                    let newCoordinates = self.calculateNewCoordinates(coordinates: myCoordinates, position: position)
                    self.getTownFrom(coordinates: newCoordinates) { town in
                        
                        switch position {
                            case Positions.North:
                                currentData.north_town = town.isEmpty ? "-" : town
                            case Positions.South:
                                currentData.south_town = town.isEmpty ? "-" : town
                            case Positions.East:
                                currentData.east_town = town.isEmpty ? "-" : town
                            case Positions.West:
                                currentData.west_town = town.isEmpty ? "-" : town
                            }
                        if !town.isEmpty {
                            switch position {
                            case Positions.North:
                                currentData.north_town = town
                            case Positions.South:
                                currentData.south_town = town
                            case Positions.East:
                                currentData.east_town = town
                            case Positions.West:
                                currentData.west_town = town
                            }
                            // Get initial town measures
                            self.getWeather(coordinates: newCoordinates) { weather in
                                
                                if weather.current.temp > currentData.hot_record {
                                    currentData.hot_record = weather.current.temp
                                    currentData.hot_record_town = town
                                }
                                if weather.current.humidity > currentData.humidity_record {
                                    currentData.humidity_record = weather.current.humidity
                                    currentData.humidity_record_town = town
                                }
                                if weather.current.rain!.inLastHour > currentData.rain_record {
                                    currentData.rain_record = weather.current.rain!.inLastHour
                                    currentData.rain_record_town = town
                                }
                                if weather.current.wind_speed > currentData.wind_record {
                                    currentData.wind_record = weather.current.wind_speed
                                    currentData.wind_record_town = town
                                }
                                success(currentData)
                                
                                
                            } failure: { error in
                                failure(error)
                            }
                        }

                    } failure: { error in
                        failure(error)
                    }
                }
                
            } failure: { error in
                failure(error)
            }
            
        } failure: { error in
            failure(error)
            
        }
        
    }
    
    private func checkIfIsZipCode(term: String) -> Bool{
     
        let regex = try! NSRegularExpression(pattern: "^\\d\\d\\d\\d\\d$")
        let range = NSRange(location: 0, length: term.utf16.count)
        return (regex.firstMatch(in: term, options: [], range: range) != nil)
        
    }
    
    private func calculateNewCoordinates(coordinates: Coordinates, position: Positions) -> Coordinates{
        
        var newCoordinates = coordinates
        switch position {
        case Positions.North:
            newCoordinates.latitude = (coordinates.latitude + Double(kDefaultDistanceKm / kEarthRKm) * (180 / Double.pi))
        case Positions.South:
            newCoordinates.latitude = (coordinates.latitude + Double(kDefaultDistanceKm / kEarthRKm) * (-180 / Double.pi))
        case Positions.East:
            newCoordinates.longitude = (kDefaultDistanceKm / kEarthRKm) * (180 / Double.pi)
            newCoordinates.longitude = (newCoordinates.longitude / cos(coordinates.latitude * (Double.pi / 180)))
            newCoordinates.longitude = (newCoordinates.longitude + coordinates.longitude)
        case Positions.West:
            newCoordinates.longitude = ((kDefaultDistanceKm / kEarthRKm) * (-180 / Double.pi))
            newCoordinates.longitude = (newCoordinates.longitude / cos(coordinates.latitude * (Double.pi / -180)))
            newCoordinates.longitude = (newCoordinates.longitude + coordinates.longitude)
        }
        return newCoordinates
        
    }
    
    private func getWeather(coordinates: Coordinates, success: @escaping (_ weather: Weather) -> (), failure: @escaping (_ error: Error) -> ()) {
        
        let url = "\(kBaseUrl)/data/3.0/onecall"
        let parameters: [String:Any] = ["lat": coordinates.latitude, "lon": coordinates.longitude, "units": kUnits, "exclude": "daily,minutely", "appid": kAccesToken]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: Weather.self){ response in
            
            switch response.result {
            case .success(let value):
                var weather:Weather = value
                // Value rain it's optional. We set by default to 0
                weather.current.rain = (weather.current.rain ?? Weather.WeatherCurrent.WeatherCurrentRain(inLastHour: 0.0))
                success(weather)
                
            case .failure(let error):
                failure(self.connectionErrors(error: error))
            }
            
        }
        
    }
    
    private func getTownFrom(coordinates: Coordinates, success: @escaping (_ town: String) -> (), failure: @escaping (_ error: Error) -> ()) {
        
        let url = "\(kBaseUrl)/geo/1.0/reverse"
        let parameters: [String:Any] = ["lat": coordinates.latitude, "lon": coordinates.longitude, "limit": 1, "appid": kAccesToken]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: [Reverse].self) { response in
            
            switch response.result {
            case .success(let value):
                if value.count > 0 {
                    success("\(value.first!.name), \(value.first!.country)")
                }else{
                    success("")
                }
            case .failure(let error):
                failure(self.connectionErrors(error: error))
            }
        }
        
    }
    
    private func getGeopoint(term: String, country: String, success: @escaping (_ place: Place) -> (), failure: @escaping (_ error: Error) -> ()) {
        
        
        let isZip = checkIfIsZipCode(term: term)
        if isZip {
            
            let url = "\(kBaseUrl)/data/2.5/weather"
            let parameters = ["zip": "\(term),\(country)", "appid": kAccesToken]
            AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: GeolocationByZip.self) { response in
                 
                 switch response.result {
                 case .success(let value):
                     success(Place(name: value.name, country: value.sys.country, lat: value.coord.lat, lon: value.coord.lon))
                 case .failure(let error):
                     failure(self.connectionErrors(error: error))
                 }
             }
            
        }else{
            
            let url = "\(kBaseUrl)/geo/1.0/direct"
            let parameters = ["q": "\(term),\(country)", "limit": "1", "appid": kAccesToken]
            AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: [Place].self) { response in
                
                switch response.result {
                case .success(let value):
                    if !value.isEmpty {
                        success(value.first!)
                    }else{
                        failure(CustomErrors.notFoundTown)
                    }
                case .failure(let error):
                    failure(self.connectionErrors(error: error))
                }
            }
            
        }
        
        
    }
    
    private func connectionErrors(error: AFError) -> CustomErrors {
        
        if error.responseCode ?? 400 == 401 {
            return CustomErrors.openWeatherMapConnectinUnauthorised
        }else{
            return CustomErrors.openWeatherMapConnectionError
        }
        
    }
    
}
