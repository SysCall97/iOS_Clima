//
//  WeatherData.swift
//  Clima
//
//  Created by Kazi Mashry on 25/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherDetails]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherDetails: Decodable {
    let id: Int
    let description: String
}
