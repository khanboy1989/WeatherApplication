//
//  Constants.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 27/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
//Keeps constants publicly in case of needed anywhere at api call or somewhere else
class Constants {
    public static let mainUrl:String = "http://api.openweathermap.org/data/2.5/weather?"
    public static let appId:String = "&appid=e8a55697f8eea7730355992322a22e49"
    public static let unitsMetric = "&units=metric"
    public static let imageUrl:String = "https://openweathermap.org/img/w/"
}
