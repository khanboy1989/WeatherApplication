//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var windDirectionImageView: UIImageView!
    @IBOutlet weak var windIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
  
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    private var client:WeatherClient = WeatherClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initialPoint() //call initial step function
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///
    ///Initial point function is responsible to handle first entrance point to application
    private func initialPoint(){
        self.activityIndicator.startAnimating()
        self.hideShowUIComponents(isHidden: true)
        self.mainLabel.isHidden = true
        let lastRecord = self.getLastWeatherInfoFromLocalStore()
        let checkInternetConnection = InternetReachability.isConnectedToNetwork()
        if  lastRecord != nil  { // checks if data nil or not
            if(checkInternetConnection) {
                self.getUserLocation() // if data not nil and there is internet connection parse updated data from api
            }
            else if (checkInternetConnection == false) { // if there is no internet connection show chached data if less 24 hours
                if (DateHelper.shared.hourDifferenceBetweenDates(date: (lastRecord!.datecreated)!) <= 24) {
                    self.updateUI(currentWeatherInfo: lastRecord)
                } else {
                    self.deleteRecordFromLocalStore(nil) // if data is more than 24 hours than show no data available by passing nill value to update ui function
                    self.updateUI(currentWeatherInfo: nil)
                }
            }
            // else if lastRecord is nil check whether there is a internet connection, if there is try to parse updated data from Openweather api
        } else if lastRecord == nil {
            if(checkInternetConnection) {
                self.getUserLocation()
            } else {
                // if there is no internet connection warn user and update UI with an nil value of lastRecord
                self.displayMsg(title: GlobalErrors.internetErrorTitle.localizedDescription, msg: GlobalErrors.internetError.localizedDescription)
                self.updateUI(currentWeatherInfo: lastRecord)
            }
        }
    }
    //Delete records if the stored data more than 24 hours. Function itself is accepts createdDate in order to delete record like SQL where condition
    private func deleteRecordFromLocalStore(_ createdDate:String?) {
        let deleteResult = self.client.deleterRecord(createdDate)
        switch deleteResult {
        case .success( _): break
        case .failure(let error):
            self.displayMsg(title: LocalDataError.deleteErrorTitle.localizedDescription, msg: error.localizedDescription)
        
        }
    }
    
    
    /// The getLastWeatherInfoFromLocalStore will check is there any registered latest weather data
    /// It will compare last update.
    private func getLastWeatherInfoFromLocalStore() -> CurrentWeatherInfo?{
        let getSavedWeatherResult = self.client.getLastRecord()
        switch getSavedWeatherResult {
        case .success(let result):
            return result
        case .failure(let error):
            self.displayMsg(title: LocalDataError.queryErrorTitle.localizedDescription, msg: error.localizedDescription)
            return nil
        }
    }
    
    ///
    ///chaches the the data which is parsed from api call
    private func chacheCurrentWeatherInfo(currentWeather:CurrentWeather,dateCreated:String){
        let saveResult = self.client.saveData(currentWeather: currentWeather, datecreated: DateHelper.shared.getCurrentDate())
        switch saveResult {
        case .success(_ ): break
        case .failure(let error):
            self.displayMsg(title: LocalDataError.saveErrorTitle.localizedDescription, msg: error.localizedDescription)
        }
    }

    
    /// The getUserLocation function will request user's current location from LocationService
    ///
    /// - returns: Users location with CLLocation variable type
    /// - throws: As an error the LocationService class will return nil value so there will be an issue with Location
    private func getUserLocation(){
        if(LocationService.shared.checkLocationServicesStatus() == true){
            self.hideShowUIComponents(isHidden: true)
            LocationService.shared.start()
            LocationService.shared.lookUpCurrentLocation { geoLoc in
                print(geoLoc?.locality ?? "unknown error")
                self.getUserCurrentLocationWeatherData(currentLocation: geoLoc?.location)
            }
            LocationService.shared.stop()
        } else {
            self.displayMsg(title: GlobalErrors.locationErrorTitle.localizedDescription, msg: GlobalErrors.locationError.localizedDescription)
            let lastRecord = self.getLastWeatherInfoFromLocalStore()
            if lastRecord != nil { // if lastRecorded data is not nil
                if (DateHelper.shared.hourDifferenceBetweenDates(date: (lastRecord!.datecreated)!) <= 24) { // if chached data is less than or equal to 24 hours show data
                    self.updateUI(currentWeatherInfo: lastRecord)
                } else {
                    self.deleteRecordFromLocalStore(nil)
                    self.updateUI(currentWeatherInfo: nil)
                }
            } else { // if cached data is nil so show no data to show
                self.deleteRecordFromLocalStore(nil)
                self.updateUI(currentWeatherInfo: nil)
            }
            
        }
    }
    
    ///
    /// The getUserCurrentLocationWeatherData function will request user's current location weather data from Services by using OpenWeather APi
    ///
    /// - parameter currentLocation: User's current location
    /// - returns: User's current location weather if (CurrentLocation is nil) returns error
    private func getUserCurrentLocationWeatherData(currentLocation:CLLocation?) {
        if  InternetReachability.isConnectedToNetwork() && currentLocation != nil {
            self.deleteRecordFromLocalStore(nil)
            let userLocation = UserLocation(latitude:String(format: "%f", currentLocation!.coordinate.latitude) , longitude: String(format:"%f", currentLocation!.coordinate.longitude))
            let postURL:URLRequest = URLRequest(url: URL(string: Constants.mainUrl + "lat=\(userLocation.latitude!)&lon=\(userLocation.longitude!)" + Constants.unitsMetric + Constants.appId)!)
                self.client.getCurrentWeatherDataCurrentLocation(from:postURL) { result in
                switch result {
                case .success(let weatherInfoResult):
                    guard (weatherInfoResult?.weather?.first?.main) != nil else {
                    self.displayMsg(title: GlobalErrors.unknownErrorTitle.localizedDescription, msg: APIError.responseUnsuccessful.localizedDescription)
                    return
                }
                    self.chacheCurrentWeatherInfo(currentWeather: weatherInfoResult!, dateCreated: DateHelper.shared.getCurrentDate())
                    let weatherResultInfo = self.getLastWeatherInfoFromLocalStore()
                    if (weatherResultInfo != nil) {
                        self.updateUI(currentWeatherInfo: weatherResultInfo)
                    }
                case .failure(let error):
                    self.activityIndicator.isHidden = true
                    self.displayMsg(title: GlobalErrors.unknownErrorTitle.localizedDescription, msg: error.localizedDescription)
                }
            }
        }else {
            self.activityIndicator.isHidden = true
            self.displayMsg(title: GlobalErrors.unknownErrorTitle.localizedDescription, msg: GlobalErrors.unknownError.localizedDescription)
        }
    }
    // updates ui depending on the currentweatherinfo if it is not nil chached or recently received one
    private func updateUI(currentWeatherInfo:CurrentWeatherInfo?) {
        if currentWeatherInfo?.main != nil {
            self.iconImageView.downloaded(from: "https://openweathermap.org/img/w/" + currentWeatherInfo!.icon! + ".png")
            self.mainLabel.text = currentWeatherInfo!.main
            self.temperatureLabel.text = currentWeatherInfo!.temp!+"°C"
            self.windSpeedLabel.text = currentWeatherInfo!.speed! + " " + "mph"
            self.windDirectionLabel.text = currentWeatherInfo!.degree
            self.cityLabel.text = currentWeatherInfo!.city! + "," + currentWeatherInfo!.country!
            self.hideShowUIComponents(isHidden: false)
            self.activityIndicator.isHidden = true
            self.mainLabel.isHidden = false
           
        } else {
            self.hideShowUIComponents(isHidden: true)
            self.activityIndicator.isHidden = true
            self.mainLabel.isHidden = false
            self.mainLabel.text = "No data"
        }
    }
    // if there is internet connection refreshes the data and makes http call if not shows alert
    @IBAction func refreshButtonTapped(_ sender: Any) {
        if (InternetReachability.isConnectedToNetwork() == true){
            self.activityIndicator.startAnimating()
            self.hideShowUIComponents(isHidden: true)
            self.activityIndicator.isHidden = false
            self.mainLabel.isHidden = true
            self.initialPoint()
        } else {
            self.hideShowUIComponents(isHidden: false)
            self.activityIndicator.isHidden = true
            self.mainLabel.isHidden = false
             self.displayMsg(title: GlobalErrors.internetErrorTitle.localizedDescription, msg: GlobalErrors.internetError.localizedDescription)
            self.initialPoint()
        }
    }
    
    //hideShowComponents function is responsible to hide or to show UI controls depending on value passed. It is created to manage component hide or show in one go.
    private func hideShowUIComponents(isHidden:Bool) {
        self.temperatureLabel.isHidden = isHidden
        self.windSpeedLabel.isHidden = isHidden
        self.windDirectionLabel.isHidden = isHidden
        self.cityLabel.isHidden = isHidden
        self.iconImageView.isHidden = isHidden
        self.windIconImageView.isHidden = isHidden
        self.windDirectionImageView.isHidden = isHidden
    }
}


