//
//  LocalDataClient.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 28/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
import CoreData
import UIKit
protocol LocalDataClient {
    func addRecord<T: NSManagedObject>(_ type : T.Type) -> Result<T?,LocalDataError>
    func allRecords<T: NSManagedObject>(_type:T.Type,sort:NSSortDescriptor?)->Result<[T],LocalDataError>
    func query<T: NSManagedObject>(_ type : T.Type, search: NSPredicate?, sort: NSSortDescriptor?, multiSort: [NSSortDescriptor]?) -> Result<[T],LocalDataError>
    func deleteRecords<T: NSManagedObject>(_ type : T.Type, search: NSPredicate?)->Result<Bool,LocalDataError>
    func saveDatabase()->Result<Bool,LocalDataError>
}

