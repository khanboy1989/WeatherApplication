//
//  Result.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
//Carries the result of either api call or localstore operations
enum Result<T,U> where U:Error {
    case success(T)
    case failure(U)
}
