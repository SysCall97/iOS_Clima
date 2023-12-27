//
//  WeatherModel.swift
//  Clima
//
//  Created by Kazi Mashry on 25/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let currentTemp: Double
    let iconId: Int

    var iconName: String {
        switch iconId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud.max"
        }
    }
}
