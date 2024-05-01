//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Bek Mashrapov on 2024-04-21.
//

import Foundation

class WeatherService {
    static func fetchWeather(for city: String, withURL urlString: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let json = try? JSONDecoder().decode(WeatherResults.self, from: data) else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data"])))
                return
            }
            completion(.success(json.main.temp))
        }.resume()
    }
}

// Assuming the WeatherResults structure looks something like this:
struct WeatherResults: Decodable {
    struct Main: Decodable {
        let temp: Double
    }
    let main: Main
}
