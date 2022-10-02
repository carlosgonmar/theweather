//
//  OpenWeatherMapModel.swift
//  TheWeather
//
//  Created by Carlos González Martín on 2/10/22.
//

import Foundation

struct OWM_Geolocation: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}

struct OWM_GeolocationByZip: Decodable {
    
    let name: String
    let coord: OWM_GeolocationByZipCoordinates
    let sys: OWM_GeolocationByZipSys
    
    struct OWM_GeolocationByZipCoordinates: Decodable {
        let lat: Double
        let lon: Double
    }

    struct OWM_GeolocationByZipSys: Decodable {
        let country: String
    }
    
}

struct OWM_GeolocationReverse: Decodable {
    
    let name: String
    let country: String
    
}

struct OWM_Weather: Decodable {
    
    let lat: Float
    let lon: Float
    var current: OWM_WeatherCurrent
    
    struct OWM_WeatherCurrent: Decodable {
        let temp: Float
        let humidity: Int
        let wind_speed: Float
        let weather: [OWM_WeatherCurrentWeather]
        var rain: OWM_WeatherCurrentRain?
        
        struct OWM_WeatherCurrentWeather: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct OWM_WeatherCurrentRain: Decodable {
            var inLastHour: Float
            
            enum CodingKeys: String, CodingKey {
                case inLastHour = "1h"
            }
        }
    }
    
}
