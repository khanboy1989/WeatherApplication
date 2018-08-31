//
//  DateHelper.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 28/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
class DateHelper:NSObject {
    static let shared = DateHelper() //Shared instance derives DateHelper class in order to make it singleton
    func getCurrentDate()->String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    //Returns hour difference
    func hourDifferenceBetweenDates(date:String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateInDateFormat = dateFormatter.date(from: date)
        if(dateInDateFormat != nil) {
            let units: Set<Calendar.Component> = [.hour, .day, .month, .year]
            let difference = Calendar.current.dateComponents(units, from: dateInDateFormat!, to: Date())
            if let hours = difference.hour {
                return hours
            }
        }
        return 0
    }
}
