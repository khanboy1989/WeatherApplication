//
//  WeatherApplicationTests.swift
//  WeatherApplicationTests
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import XCTest
@testable import WeatherApplication

class WeatherApplicationTests: XCTestCase {
    
    let client:WeatherClient = WeatherClient()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    //Tests if the users location service enabled function works correctly or not.
    func testLocationServiceEnabled () {
        let isLocationEnabled = LocationService.shared
        let result =  isLocationEnabled.checkLocationServicesStatus()
        XCTAssertEqual(result, true)
    }
    //Tests if application has corrects permission to receive user's current location in a correct way.
    func testlookUpCurrentLocation() {
        LocationService.shared.start()
        LocationService.shared.lookUpCurrentLocation { geoLoc in
            print("The gecoloc is:" + (geoLoc?.locality)!)
            XCTAssertNotNil(geoLoc)
        }
        LocationService.shared.stop()
    }
    //test the HTTP request of getting weather depending on latitude and longitude is provided to function.
    func testGetWeatherData() {
        let postURL:URLRequest = URLRequest(url: URL(string: Constants.mainUrl + "lat=35&lon=139" + Constants.unitsMetric + Constants.appId)!)
        let expectations = expectation(description: "foobar")
        self.client.getCurrentWeatherDataCurrentLocation(from:postURL) { result in
            switch result {
            case .success(let weatherInfoResult):
            XCTAssertNotNil(weatherInfoResult!.weather!.first!.description)
            case .failure(let error):
                print("the error \(error)")
                XCTAssertNil(error)
            }
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    //Tests saving data to local store.
    func testSaveDataToLocalStore() {
        let weatherInfo:CurrentWeather = CurrentWeather(coord: nil, weather: [WeatherDetails(id: nil, main: "Clear", description: "Clear Sky", icon: "01n")], base: nil, main: Main(temp: 32.5, pressure: 3.5, humidity: 5.5, tempMin: 23.5, tempMax: 37.0), visibility: nil, wind: Wind(speed: 3.5, deg: 100), clouds: nil, dt: nil, sys: nil, id: nil, name: "Nicosia")
        
        let saveOperation = self.client.saveData(currentWeather: weatherInfo, datecreated: DateHelper.shared.getCurrentDate())
        
        switch saveOperation{
        case.success(let result):
            print("Save result is: \(result)")
            XCTAssertEqual(result, true)
        case .failure(let error):
            XCTAssertEqual(error, .saveError)
        }
        
    }
    //tests deleting stored data to local store.
    func testDeleteRecordFromLocalStore() {
        let deleteResult = self.client.deleterRecord(nil)
        switch deleteResult {
        case .success(let result):
            XCTAssertEqual(result, true)
        case .failure(let error):
            XCTAssertEqual(error, .deleteError)
        }
    }
    //tests getting stored data .
    func testGetDataFromLocalStore() {
        let getLastRecord = self.client.getLastRecord()
        switch getLastRecord {
        case .success(let result):
            if (result != nil) {
                print("The main result date created:" + (result?.datecreated)!)
                XCTAssertNotNil(result)
            } else {
                XCTAssertNil(result)
            }
            
        case.failure(let error):
                XCTAssertEqual(error, .queryError)
        
        }
    }
    
    func testInternetConnectio() {
       let isInternetConnected =  InternetReachability.isConnectedToNetwork()
        if isInternetConnected {
            XCTAssertEqual(isInternetConnected, true)
        } else {
            XCTAssertEqual(isInternetConnected, false)
        }
    }
    
    func testConvertDegreetoDirection(){
        let direction = 210.0.windDirectionFromDegrees()
        print(direction)
    }
    
}
