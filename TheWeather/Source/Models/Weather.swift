//
//  Weather.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import Foundation

struct Weather: Decodable {
    let lat: Float
    let lon: Float
    var current: WeatherCurrent
    
    struct WeatherCurrent: Decodable {
        let temp: Float
        let humidity: Int
        let wind_speed: Float
        let weather: [WeatherCurrentWeather]
        var rain: WeatherCurrentRain?
        
        struct WeatherCurrentWeather: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct WeatherCurrentRain: Decodable {
            var inLastHour: Float
            
            enum CodingKeys: String, CodingKey {
                case inLastHour = "1h"
            }
        }
    }
}


