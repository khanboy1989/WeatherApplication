//
//  LocalDataClientExtension.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 29.08.2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
import CoreData
import UIKit
extension LocalDataClient {
    
    func addRecord<T: NSManagedObject>(_ type : T.Type) -> Result<T?,LocalDataError>
    {
        let entityName = String(describing: T.self)
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDel.persistentContainer.viewContext
        let contxt :NSManagedObjectContext = managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: contxt)
        if(entity != nil) {
            let record = T(entity: entity!, insertInto: contxt)
            return Result.success(record)
        }else {
            return Result.failure(.saveError)
        }
    }
    
    func query<T: NSManagedObject>(_ type : T.Type, search: NSPredicate?, sort: NSSortDescriptor?, multiSort: [NSSortDescriptor]?) -> Result<[T],LocalDataError>
    {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDel.persistentContainer.viewContext
        let context :NSManagedObjectContext = managedObjectContext
        let request = T.fetchRequest()
        if let predicate = search
        {
            request.predicate = predicate
        }
        if let sortDescriptors = multiSort
        {
            request.sortDescriptors = sortDescriptors
        }
        else if let sortDescriptor = sort
        {
            request.sortDescriptors = [sortDescriptor]
        }
        do
        {
            let results = try context.fetch(request)
            return Result.success(results as! [T])
        }
        catch
        {
            return Result.failure(.queryError)
        }
    }
    
    func deleteRecords<T: NSManagedObject>(_ type : T.Type, search: NSPredicate?)->Result<Bool,LocalDataError>{
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDel.persistentContainer.viewContext
        let context :NSManagedObjectContext = managedObjectContext
        let results = query(T.self, search: search, sort:nil,multiSort:nil)
        switch results {
        case .success(let result):
            for record in result
            {
                context.delete(record)
            }
            return Result.success(true)
        case .failure(let error):
            return Result.failure(error)
        }
        
    }
    
    func allRecords<T: NSManagedObject>(_type: T.Type, sort: NSSortDescriptor?) -> Result<[T],LocalDataError>
    {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDel.persistentContainer.viewContext
        let context :NSManagedObjectContext = managedObjectContext
        let request = T.fetchRequest()
        do
        {
            let results = try context.fetch(request)
            return Result.success(results as! [T])
        }
        catch
        {
            return Result.failure(.queryError)
        }
    }
    
    
    func saveDatabase()->Result<Bool,LocalDataError>
    {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDel.persistentContainer.viewContext
        let context :NSManagedObjectContext = managedObjectContext
        
        do
        {
            try context.save()
            return Result.success(true)
        }
        catch
        {
            return Result.failure(.saveError)
        }
    }
    
}
