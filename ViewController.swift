//
//  ViewController.swift
//  WeatherApp Final
//
//  Created by Bek Mashrapov on 2024-04-18.
//

import Foundation

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var cities = [String]()
    var cityTemperatures = [String: Double]() // This dictionary will store city and temperature data
    var cityTodos = [String: [String]]() // Stores todos for each city
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cities"
        
        // Setup TableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCitiesTapped))
    }
    
    @objc func addCitiesTapped() {
        let addCityVC = AddCityViewController()
        addCityVC.onSave = { [weak self] selectedCities in
            self?.cities.append(contentsOf: selectedCities)
            self?.fetchWeatherForCities()
            self?.tableView.reloadData()
        }
        let navController = UINavigationController(rootViewController: addCityVC)
        present(navController, animated: true, completion: nil)
    }
    
    func fetchWeatherForCities() {
        for city in cities {
            let weatherURL = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=7d98413a2502d308bea1925738a96b8f&units=metric" // units=metric will directly give you Celsius
            guard let url = URL(string: weatherURL) else {
                print("Invalid URL for city: \(city)")
                continue
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching weather: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received for city: \(city)")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let main = json["main"] as? [String: Any],
                       let temp = main["temp"] as? Double {
                        
                        DispatchQueue.main.async {
                            self?.cityTemperatures[city] = temp
                            self?.tableView.reloadData()
                        }
                    } else {
                        print("Could not parse JSON for city: \(city)")
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
    }

    
    // Required UITableViewDataSource methods
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return cities.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cellIdentifier = "CityTemperatureCell"
          let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
          let city = cities[indexPath.row]
          cell.textLabel?.text = city
          if let temperature = cityTemperatures[city] {
              cell.detailTextLabel?.text = "\(temperature)°C"
          } else {
              cell.detailTextLabel?.text = "Loading..."
          }
          return cell
      }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let city = cities[indexPath.row]
          let todoVC = TodoListViewController()
          todoVC.cityName = city
          todoVC.todos = cityTodos[city] ?? []
          todoVC.onTodosUpdated = { [weak self] updatedTodos in
              self?.cityTodos[city] = updatedTodos
              // Optional: Save updated todos to persistent storage here
          }
          navigationController?.pushViewController(todoVC, animated: true)
      }
}

