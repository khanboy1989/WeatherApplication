//
//  HelperExtensions.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 28/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
import UIKit
//Converts double degree value to string description for wind directio
extension Double {
    func windDirectionFromDegrees() -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((Double(self) + 11.25)/22.5)
        return directions[i % 16]
    }
    
    func kelvinToCelsius() -> String {
        let temperatureInCelsius = self - 273.15
        return String(format: "%.0f", temperatureInCelsius)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}




