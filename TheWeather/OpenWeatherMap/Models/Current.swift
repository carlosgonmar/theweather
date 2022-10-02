//
//  Current.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import Foundation

struct Current {
    var town: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var weather: String = ""
    var description: String = ""
    var icon: String = ""
    var hot_record: Float = 0
    var hot_record_town: String = ""
    var humidity_record: Int = 0
    var humidity_record_town: String = ""
    var rain_record: Float = 0
    var rain_record_town: String = ""
    var wind_record: Float = 0
    var wind_record_town: String = ""
}
