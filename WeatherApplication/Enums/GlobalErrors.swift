//
//  GlobalErrors.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 30/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
// handles global error messages 
enum GlobalErrors {
    case internetError
    case locationError
    case unknownError
    case internetErrorTitle
    case locationErrorTitle
    case unknownErrorTitle
    var localizedDescription: String {
        switch self {
        case .internetError: return "Please enable your internet connection."
        case .locationError: return "Please enable your location."
        case .unknownError: return "An unknown error occured."
        case .internetErrorTitle : return  "Internet Error"
        case .locationErrorTitle: return "Location Error"
        case .unknownErrorTitle: return "Error"
        }
    }
}
