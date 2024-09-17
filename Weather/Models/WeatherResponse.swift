//
//  File.swift
//  Weather
//
//  Created by Paresh  Thakkar on 9/17/24.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
   // let weatherIcon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
