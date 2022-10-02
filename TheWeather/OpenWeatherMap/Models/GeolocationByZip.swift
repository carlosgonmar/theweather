//
//  GeolocationByZip.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import Foundation

struct GeolocationByZip: Decodable {
    let name: String
    let coord: GeolocationByZipCoordinates
    let sys: GeolocationByZipSys
}

struct GeolocationByZipCoordinates: Decodable {
    let lat: Double
    let lon: Double
}

struct GeolocationByZipSys: Decodable {
    let country: String
}
