//
//  CustomErrors.swift
//  TheWeather
//
//  Created by Carlos González Martín on 1/10/22.
//

import Foundation

enum CustomError: Error {
    case openWeatherMapConnectinUnauthorised
    case openWeatherMapConnectionError
    case notFoundTown
    case missingTown
    case unexpected
}
extension CustomError {
    var isFatal: Bool {
        if case CustomError.unexpected = self { return true }
        else { return false }
    }
}
extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .openWeatherMapConnectinUnauthorised:
            return "OpenWeatherMap does not authorise the use of its API."
        case .openWeatherMapConnectionError:
            return "We are having difficulties connecting to OpenWeatherMap, please try again later."
        case .notFoundTown:
            return "We did not find the city you are looking for."
        case .missingTown:
            return "Something is wrong here. missingTown"
        case .unexpected:
            return "An unexpected error occurred."
        }
    }
}
