//
//  WeatherManagerProtocol.swift
//  Clima
//
//  Created by Kazi Mashry on 22/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerProtocol {
    func fetchWeather(from cityName: String) async throws -> WeatherModel
}
