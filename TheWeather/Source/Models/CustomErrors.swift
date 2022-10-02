//
//  CustomErrors.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import Foundation

enum CustomErrors: LocalizedError {
    case openWeatherMapConnectinUnauthorised
    case openWeatherMapConnectionError
    case notFoundTown
    case missingTown

    var errorDescription: String? {
        switch self {
        case .openWeatherMapConnectinUnauthorised:
            return "OpenWeatherMap does not authorise the use of its API."
        case .openWeatherMapConnectionError:
            return "We are having difficulties connecting to OpenWeatherMap, please try again later."
        case .notFoundTown:
            return "We did not find the city you are looking for."
        case .missingTown:
            return "Something is wrong here. missingTown"
        }
    }
}
