//
//  OpenWeatherMapManager.swift
//  TheWeather
//
//  Created by Carlos González Martín on 4/10/22.
//

import Foundation
import Alamofire

final class OpenWeatherMapManager {
    
    static let shared = OpenWeatherMapManager()
    private let kBaseUrl = "https://api.openweathermap.org"
    private var kAccesToken = ""
    private let kUnits = "metric"
    private let kEarthRKm: Double = 6378.137
    private let kDefaultDistanceKm: Double = 200
    
    private init() {
        
        kAccesToken = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherMapToken") as? String ?? ""
        
    }
    
    private func connectionErrors(error: AFError) -> CustomError {
        
        if error.responseCode ?? 400 == 401 {
            return CustomError.openWeatherMapConnectinUnauthorised
        }else{
            return CustomError.openWeatherMapConnectionError
        }
        
    }
    
    //public func getTheWeatherInfo(query :String) -> TheWeatherInfo {
    
    public func getTheWeatherInfo(
        query :String,
        completion: @escaping (Result<TheWeatherInfo, Error>) -> Void
    ){
        
        self.geolocationWithString(query: query) { result in
            switch result{
            case .success(let place):
                
                self.getTheWeatherInfoFromPlace(place: place) { result in
                    switch result{
                    case .success(let weatherInfo):
                        
                        completion(.success(weatherInfo))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    public func getTheWeatherInfoFromPlace(
        place :Place,
        completion: @escaping (Result<TheWeatherInfo, Error>) -> Void
    ){
        
        var weatherInfo = TheWeatherInfo()
        weatherInfo.centerPlace = place
        // Search center place weather
        self.weather(latitude: place.latitude, longitude: place.longitude) { result in
            switch result{
            case .success(let newWeatherInfo):
                
                weatherInfo = self.compareWeather(place: place, currentWeatherInfo: weatherInfo, newWeatherInfo: newWeatherInfo)
                
                // North place
                weatherInfo.northPlace = self.calculateNewCoordinates(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude, position: Positions.North)
                self.reverseGeolocation(latitude: weatherInfo.northPlace!.latitude, longitude: weatherInfo.northPlace!.longitude) { result in
                    switch result{
                    case .success(let town):
                        
                        weatherInfo.northPlace!.name = "\(town)"
                        self.weather(latitude: weatherInfo.northPlace!.latitude, longitude: weatherInfo.northPlace!.longitude) { result in
                            switch result{
                            case .success(let newWeatherInfo):
                                
                                weatherInfo = self.compareWeather(place: weatherInfo.northPlace!, currentWeatherInfo: weatherInfo, newWeatherInfo: newWeatherInfo)
                                
                                // South place
                                weatherInfo.southPlace = self.calculateNewCoordinates(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude, position: Positions.South)
                                self.reverseGeolocation(latitude: weatherInfo.southPlace!.latitude, longitude: weatherInfo.southPlace!.longitude) { result in
                                    switch result{
                                    case .success(let town):
                                        
                                        weatherInfo.southPlace!.name = "\(town)"
                                        self.weather(latitude: weatherInfo.southPlace!.latitude, longitude: weatherInfo.southPlace!.longitude) { result in
                                            switch result{
                                            case .success(let newWeatherInfo):
                                                
                                                weatherInfo = self.compareWeather(place: weatherInfo.southPlace!, currentWeatherInfo: weatherInfo, newWeatherInfo: newWeatherInfo)
                                                
                                                // East place
                                                weatherInfo.eastPlace = self.calculateNewCoordinates(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude, position: Positions.East)
                                                self.reverseGeolocation(latitude: weatherInfo.eastPlace!.latitude, longitude: weatherInfo.eastPlace!.longitude) { result in
                                                    switch result{
                                                    case .success(let town):
                                                        
                                                        weatherInfo.eastPlace!.name = "\(town)"
                                                        self.weather(latitude: weatherInfo.eastPlace!.latitude, longitude: weatherInfo.eastPlace!.longitude) { result in
                                                            switch result{
                                                            case .success(let newWeatherInfo):
                                                                
                                                                weatherInfo = self.compareWeather(place: weatherInfo.eastPlace!, currentWeatherInfo: weatherInfo, newWeatherInfo: newWeatherInfo)
                                                                
                                                                // West place
                                                                weatherInfo.westPlace = self.calculateNewCoordinates(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude, position: Positions.West)
                                                                self.reverseGeolocation(latitude: weatherInfo.westPlace!.latitude, longitude: weatherInfo.westPlace!.longitude) { result in
                                                                    switch result{
                                                                    case .success(let town):
                                                                        
                                                                        weatherInfo.westPlace!.name = "\(town)"
                                                                        self.weather(latitude: weatherInfo.westPlace!.latitude, longitude: weatherInfo.westPlace!.longitude) { result in
                                                                            switch result{
                                                                            case .success(let newWeatherInfo):
                                                                                
                                                                                weatherInfo = self.compareWeather(place: weatherInfo.westPlace!, currentWeatherInfo: weatherInfo, newWeatherInfo: newWeatherInfo)
                                                                                completion(.success(weatherInfo))
                                                                                
                                                                                
                                                                            case .failure(let error):
                                                                                completion(.failure(error))
                                                                            }
                                                                        }
                                                                        
                                                                    case .failure(let error):
                                                                        completion(.failure(error))
                                                                    }
                                                                }
                                                                // END West place
                                                                
                                                                
                                                            case .failure(let error):
                                                                completion(.failure(error))
                                                            }
                                                        }
                                                        
                                                    case .failure(let error):
                                                        completion(.failure(error))
                                                    }
                                                }
                                                // END South place
                                                
                                                
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                                // End North place
                                
                                
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
    
    private func compareWeather(place: Place, currentWeatherInfo: TheWeatherInfo, newWeatherInfo: OWM_Weather) -> TheWeatherInfo{
        
        let town = !place.name.isEmpty ? "\(place.name), \(place.country)" : "-"
        var weatherInfo: TheWeatherInfo = currentWeatherInfo
        
        if newWeatherInfo.current.temp > currentWeatherInfo.hot_record {
            weatherInfo.hot_record = newWeatherInfo.current.temp
            weatherInfo.hot_record_town = town
        }
        if newWeatherInfo.current.humidity > currentWeatherInfo.humidity_record {
            weatherInfo.humidity_record = newWeatherInfo.current.humidity
            weatherInfo.humidity_record_town = town
        }
        if let rain = newWeatherInfo.current.rain {
            if rain.inLastHour > currentWeatherInfo.rain_record {
                weatherInfo.rain_record = newWeatherInfo.current.rain!.inLastHour
                weatherInfo.rain_record_town = town
            }
        }
        if newWeatherInfo.current.wind_speed > currentWeatherInfo.wind_record {
            weatherInfo.wind_record = newWeatherInfo.current.wind_speed
            weatherInfo.wind_record_town = town
        }
        return weatherInfo
        
    }
    
    private func checkIfIsZipCode(term: String) -> Bool{
        
        // Check via regex if the incoming text has the format of a postcode, which is composed of exactly 5 digits.
        let regex = try! NSRegularExpression(pattern: "^\\d\\d\\d\\d\\d,?\\s?(\\w\\w)?]?$")
        let range = NSRange(location: 0, length: term.utf16.count)
        return (regex.firstMatch(in: term, options: [], range: range) != nil)
        
    }
    
    private func calculateNewCoordinates(latitude: Double, longitude: Double, position: Positions) -> Place {
        
        // Calculate coordinates from a latitude and longitude in the given
        // direction (north, south, east, west) using the default distance defined in kDefaultDistanceKm
        var newLatitude = latitude
        var newLongitude = longitude
        switch position {
        case Positions.North:
            newLatitude = (latitude + Double(kDefaultDistanceKm / kEarthRKm) * (180 / Double.pi))
        case Positions.South:
            newLatitude = (latitude + Double(kDefaultDistanceKm / kEarthRKm) * (-180 / Double.pi))
        case Positions.East:
            newLongitude = (kDefaultDistanceKm / kEarthRKm) * (180 / Double.pi)
            newLongitude = (newLongitude / cos(latitude * (Double.pi / 180)))
            newLongitude = (newLongitude + longitude)
        case Positions.West:
            newLongitude = ((kDefaultDistanceKm / kEarthRKm) * (-180 / Double.pi))
            newLongitude = (newLongitude / cos(latitude * (Double.pi / -180)))
            newLongitude = (newLongitude + longitude)
        }
        return Place(latitude: newLatitude, longitude: newLongitude)
        
    }
    
    private func geolocationWithString(
        query :String,
        completion: @escaping (Result<Place, Error>) -> Void
    ){
        
        if checkIfIsZipCode(term: query) {
            
            let url = "\(kBaseUrl)/data/2.5/weather"
            let parameters = ["zip": "\(query)","limit": "1", "appid": kAccesToken]
            AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: OWM_GeolocationByZip.self) { response in
                
                switch response.result {
                case .success(let value):
                    let place = Place(name: value.name, country: value.sys.country, latitude: value.coord.lat, longitude: value.coord.lon)
                    completion(.success(place))
                case .failure(let error):
                    completion(.failure(self.connectionErrors(error: error)))
                }
                
            }
            
        }else{
            
            let url = "\(kBaseUrl)/geo/1.0/direct"
            let parameters = ["q": "\(query)","limit": "1", "appid": kAccesToken]
            AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: [OWM_Geolocation].self) { response in
                
                switch response.result {
                case .success(let value):
                    if !value.isEmpty {
                        let place = Place(name: value.first!.name, country: value.first!.country, latitude: value.first!.lat, longitude: value.first!.lon)
                        completion(.success(place))
                    }else{
                        completion(.failure(CustomError.notFoundTown))
                    }
                case .failure(let error):
                    completion(.failure(self.connectionErrors(error: error)))
                }
                
            }
            
        }
        
    }
    
    private func geolocationWithZip(
        query :String,
        completion: @escaping (Result<Place, Error>) -> Void
    ){
        
        let zip = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = "\(kBaseUrl)/data/2.5/weather"
        let parameters = ["zip": zip,"appid": kAccesToken]
        AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: OWM_GeolocationByZip.self) { response in
            
            switch response.result {
            case .success(let value):
                let place = Place(name: value.name, country: value.sys.country, latitude: value.coord.lat, longitude: value.coord.lon)
                completion(.success(place))
            case .failure(let error):
                completion(.failure(self.connectionErrors(error: error)))
            }
            
        }
        
    }
    
    private func reverseGeolocation(
        latitude :Double, longitude: Double,
        completion: @escaping (Result<String, Error>) -> Void
    ){
        
        let url = "\(kBaseUrl)/geo/1.0/reverse"
        let parameters: [String:Any] = ["lat": latitude, "lon": longitude, "limit": 1, "appid": kAccesToken]
        AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: [OWM_GeolocationReverse].self) { response in
            
            switch response.result {
            case .success(let value):
                var town = "-"
                if value.count > 0 {
                    town = "\(value.first!.name), \(value.first!.country)"
                }
                completion(.success(town))
            case .failure(let error):
                completion(.failure(self.connectionErrors(error: error)))
            }
            
        }
        
    }
    
    private func weather(
        latitude :Double, longitude: Double,
        completion: @escaping (Result<OWM_Weather, Error>) -> Void
    ){
        
        let url = "\(kBaseUrl)/data/3.0/onecall"
        let parameters: [String:Any] = ["lat": latitude, "lon": longitude, "units": kUnits, "exclude": "daily,minutely", "appid": kAccesToken]
        AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: OWM_Weather.self) { response in
            
            switch response.result {
            case .success(let value):
                var weather:OWM_Weather = value
                // Value rain it's optional. We set by default to 0
                weather.current.rain = (weather.current.rain ?? OWM_Weather.OWM_WeatherCurrent.OWM_WeatherCurrentRain(inLastHour: 0.0))
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(self.connectionErrors(error: error)))
            }
            
        }
        
    }
    
}
