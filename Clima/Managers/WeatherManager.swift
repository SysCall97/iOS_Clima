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
        let icon = self.parseIconString(from: weatherData.weather.first!.id)
        return WeatherModel(cityName: weatherData.name, currentTemp: weatherData.main.temp, icon: icon)
    }
    
    private func parseIconString(from weatherId: Int) -> String {
        switch weatherId {
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
