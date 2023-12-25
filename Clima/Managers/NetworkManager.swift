//
//  NetworkManager.swift
//  Clima
//
//  Created by Kazi Mashry on 22/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestFailed
    case notFound
    case authenticationError
    case serverError
    case noInternetConnection
    
    var message: String {
        get {
            switch self {
            case .requestFailed:
                return "Request failed. Try later"
            case .notFound:
                return "City not found"
            case .authenticationError:
                return "Authenticatio failed"
            case .serverError:
                return "Server error"
            case .noInternetConnection:
                return "No internet connection"
            }
        }
    }
}

final class NetworkManager: NetworkManagerProtocol {
    func getRequest<T>(from urlString: String) async throws -> T where T : Decodable {
        // 1. create URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.requestFailed
        }
        
        // 2. create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 5
        
        // 3. give session a task
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.requestFailed
            }
            
            if httpResponse.statusCode == 401 {
                throw NetworkError.authenticationError
            }
            
            if httpResponse.statusCode == 404 {
                throw NetworkError.notFound
            }
            
            if httpResponse.statusCode == 500 {
                throw NetworkError.serverError
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                throw NetworkError.requestFailed
            }
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw NetworkError.noInternetConnection
            } else {
                throw error
            }
        }
    }
    
}
