//
//  Current.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import Foundation

struct DataToPrint {
    var term: String = ""
    var town: String = "Madrid"
    var country: String = "ES"
    var latitude: Double = 40.41835349621259
    var longitude: Double = -3.6870897507878024
    var weather: String = "Clouds"
    var description: String = "overcast clouds"
    var icon: String = ""
    var north_town: String = "-"
    var north_latitude: Double = 0
    var north_longitude: Double = 0
    var south_town: String = "-"
    var south_latitude: Double = 0
    var south_longitude: Double = 0
    var east_town: String = "-"
    var east_latitude: Double = 0
    var east_longitude: Double = 0
    var west_town: String = "-"
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
}
