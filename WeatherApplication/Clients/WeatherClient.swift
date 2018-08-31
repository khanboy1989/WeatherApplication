//
//  WeatherClient.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
//All the Weather related works are done by the WeatherClient.
//WeatherClient class is responsible to provide functionality of HTTP calls of weather related and also it is responsible to provide functionality of Local Store works. It can be seen that it references APIClient and LocalDataClient protocols.
class WeatherClient:APIClient,LocalDataClient {
    
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //Make current weather info depending on the url provided
    func getCurrentWeatherDataCurrentLocation(from weatherInfoType:URLRequest, completion: @escaping (Result<CurrentWeather?, APIError>) -> Void) {
        fetch(with: weatherInfoType , decode: { json -> CurrentWeather? in
            guard let weatherResult = json as? CurrentWeather else { return  nil }
            return weatherResult
        }, completion: completion)
    }
    //Saves data to localstore
    //with the help of generic LocationDataClient protocol
    func saveData(currentWeather:CurrentWeather,datecreated:String)->Result<Bool,LocalDataError> {
        let entity = addRecord(CurrentWeatherInfo.self)
        switch entity {
        case .success(let newRecord):
            newRecord?.main = currentWeather.weather!.first!.main
            newRecord?.temp = String(format:"%.2f",currentWeather.main!.temp!)
            newRecord?.speed = String(format:"%.2f",currentWeather.wind!.speed!)
            newRecord?.degree = currentWeather.wind!.deg!.windDirectionFromDegrees()
            newRecord?.icon = currentWeather.weather!.first!.icon
            newRecord?.datecreated = datecreated
            newRecord?.city = currentWeather.name
            newRecord?.country = currentWeather.sys?.country
            let saveResult = saveDatabase()
            switch saveResult {
            case .success(let result):
                return Result.success(result)
            case  .failure(let error):
                return Result.failure(error)
            }
        case .failure(let error) :
            return Result.failure(error)
        }
    }    
    //Deletes record for given date and time
    func deleterRecord(_ datecreated:String?)->Result<Bool,LocalDataError> {
        var deleteResult:Result<Bool,LocalDataError> = Result.failure(.deleteError)
        if datecreated != nil {
            deleteResult =  deleteRecords(CurrentWeatherInfo.self, search: NSPredicate(format: "datecreated == %@",datecreated!))
        } else {
            deleteResult = deleteRecords(CurrentWeatherInfo.self, search:nil)
        }
        switch deleteResult {
        case .success( _):
            let saveResult  = saveDatabase()
            switch saveResult {
            case .success(let result) :
                return Result.success(result)
            case .failure(let error):
                return Result.failure(error)
            }
        case.failure(let error):
            return Result.failure(error)
        }
    }
  
    //return all saved records at local store with the help of generic LocalStoreClient protocol
    func getLastRecord()->Result<CurrentWeatherInfo?,LocalDataError> {
    let result = allRecords(_type: CurrentWeatherInfo.self, sort: nil)
        switch result {
        case .success(let record):
                return Result.success(record.last)
        case .failure(let error):
                return Result.failure(error)
        }
    }
}
