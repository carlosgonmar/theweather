//
//  TheWeather.swift
//  TheWeather
//
//  Created by Carlos González Martín on 4/10/22.
//

import Foundation

struct TheWeatherInfo {
    
    var centerPlace: Place = Place(latitude: 40.416001015891396, longitude: -3.7028825970895105)
    var northPlace: Place?
    var southPlace: Place?
    var eastPlace: Place?
    var westPlace: Place?
    var hot_record: Float = 0
    var hot_record_town: String?
    var humidity_record: Int = 0
    var humidity_record_town: String?
    var rain_record: Float = 0
    var rain_record_town: String?
    var wind_record: Float = 0
    var wind_record_town: String?
    
}
