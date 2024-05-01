//
//  Service.swift
//  WeatherApp
//
//  Created by Bek Mashrapov on 2024-04-20.
//

//https://gd.geobytes.com/AutoCompleteCity?callback=?&q=tor
import Foundation
class Service {
    static var shared = Service()
    private init() {}
    enum error: Error {
        case badURL
    }
    func getData(url : String,query : [String:String]?, completion: @escaping (Result<Data,Error>)->Void) {

        
        var urlComponent = URLComponents(string: url)!
        if let query = query {

            urlComponent.queryItems = query.map(
                { URLQueryItem(name: $0.key, value: $0.value) }
            )
        }
        guard let url = urlComponent.url else {
            completion(.failure(error.badURL))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                print(data)
                completion(.success(data))
            }
        }.resume()
        
    }
    
}
