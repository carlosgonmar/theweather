//
//  TheWeatherApp.swift
//  TheWeather
//
//  Created by Carlos González Martín on 30/9/22.
//

import SwiftUI

@main
struct TheWeatherApp: App {
    @StateObject private var principalData = PrincipalDataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withErrorHandling()
        }
    }
}
