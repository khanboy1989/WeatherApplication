//
//  APIError.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
//Gives chance to handle errors on API Calls generically
enum APIError:Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "The request has been failed please check your connection or remote server is not available right now."
        case .invalidData: return "The requested data is not valid."
        case .responseUnsuccessful: return "The request has ben unsuccesful please check your connection."
        case .jsonParsingFailure: return "Data parsing error."
        case .jsonConversionFailure: return "Data conversion error."
        }
    }
    
}
