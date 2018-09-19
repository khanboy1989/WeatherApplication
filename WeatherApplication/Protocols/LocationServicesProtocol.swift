//
//  LocationServiceClient.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 19.09.2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
import CoreLocation

protocol  LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
}


protocol  LocationServicesProtocol {
    func tracingLocation(currentLocation: CLLocation?)
    func tracingLocationDidFailWithError(error: Error)
}
