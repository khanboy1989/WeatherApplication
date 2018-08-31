//
//  LocalDataError.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 29.08.2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
// Provides generic error handling ability depending on results for each operation
enum LocalDataError:Error {
    case saveError
    case queryError
    case deleteError
    case deleteErrorTitle
    case queryErrorTitle
    case saveErrorTitle
    var localizedDescription: String {
        switch self {
        case .saveError: return "An error occured during saving data to local store."
        case .queryError: return "An error occured during query."
        case .deleteError: return "Data could not be deleted from local store. "
        case .deleteErrorTitle: return "Data Delete Error"
        case .queryErrorTitle: return "Query Error"
        case .saveErrorTitle : return "Data Save Error"
        }
    }
    
}
