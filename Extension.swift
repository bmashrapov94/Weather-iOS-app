//
//  Extension.swift
//  WeatherApp
//
//  Created by Bek Mashrapov on 2024-04-20.
//

import Foundation


extension String {
    func cleanJson() -> String {
        let start = self.index(self.startIndex, offsetBy: 2)
        let end = self.index(self.endIndex, offsetBy: -3)
        let range = start...end
        return  String(self[range])
    }
}
