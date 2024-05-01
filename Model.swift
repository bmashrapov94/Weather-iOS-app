//
//  Model.swift
//  WeatherApp
//
//  Created by Bek Mashrapov on 2024-04-20.
//

import Foundation

struct weatherResults : Codable {
    var weather  : [Weather]?
    var main : Main
}
struct Main : Codable{
    var temp : Float
    
}
struct Weather : Codable {
    var icon : String?
}
 
