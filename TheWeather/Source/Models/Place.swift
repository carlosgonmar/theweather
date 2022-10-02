//
//  Places.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import Foundation

struct Place: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}
