//
//  WeatherManager.swift
//  Clima
//
//  Created by Kazi Mashry on 22/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager: WeatherManagerProtocol {
    var networkManager: NetworkManagerProtocol
    
    func fetchWeather(from cityName: String) async throws -> WeatherModel {
        let url = "\(CommonConstants.weatherBaseUrlString)&q=\(cityName)"
        do {
            let weatherData: WeatherData = try await networkManager.getRequest(from: url)
            return self.parseWeatherModel(from: weatherData)
        } catch {
            throw error
        }
    }
    
    private func parseWeatherModel(from weatherData: WeatherData) -> WeatherModel {
        return WeatherModel(cityName: weatherData.name, currentTemp: weatherData.main.temp, iconId: weatherData.weather.first!.id)
    }
    
}
