//
//  CurrentWeatherInfo+CoreDataProperties.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 31.08.2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentWeatherInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherInfo> {
        return NSFetchRequest<CurrentWeatherInfo>(entityName: "CurrentWeatherInfo")
    }

    @NSManaged public var city: String?
    @NSManaged public var datecreated: String?
    @NSManaged public var degree: String?
    @NSManaged public var direction: String?
    @NSManaged public var icon: String?
    @NSManaged public var main: String?
    @NSManaged public var speed: String?
    @NSManaged public var temp: String?
    @NSManaged public var country: String?

}
