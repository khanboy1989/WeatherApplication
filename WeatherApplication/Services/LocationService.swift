//
//  LocationService.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 27/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation
import CoreLocation
class LocationService:NSObject,CLLocationManagerDelegate {

    static let shared = LocationService() //Shared instance derives LocationService class in order to make it singleton
    let locationManager:CLLocationManager // Location manager instance
    
    ///Constactor of singleton LocationManager class
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    ///
    ///the start function leads to starting of location request from user's device
    ///
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            NotificationCenter.default.post(name: Notification.Name("DidAuthorizationChanged"), object: nil, userInfo: ["status":false])
            break
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: Notification.Name("DidAuthorizationChanged"), object: nil, userInfo: ["status":true])
            break
        case .authorizedAlways:
            NotificationCenter.default.post(name: Notification.Name("DidAuthorizationChanged"), object: nil, userInfo: ["status":true])

            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            NotificationCenter.default.post(name: Notification.Name("DidAuthorizationChanged"), object: nil, userInfo: ["status":false])

            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            NotificationCenter.default.post(name: Notification.Name("DidAuthorizationChanged"), object: nil, userInfo: ["status":false])
            break
        }
    }
    
    ///
    /// The lookUpCurrentLocation returns users location instantly for one time only
    ///
    /// - parameter completionHandler: is used to completion of location request from LocationService class
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
            let geocoder = CLGeocoder()
            let lastLocation:CLLocation? = self.locationManager.location
            if let lastLoc = lastLocation {
                // Look up the location and pass it to the completion handler
                geocoder.reverseGeocodeLocation(lastLoc, completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                    }
                    else {
                        // An error occurred during geocoding.
                        completionHandler(nil)
                    }
                })
            }
            else {
                // No location was available.
                completionHandler(nil)
            }
    }
    
    ///
    /// the stop function stops sending location service requests.
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    ///
    /// locationManager function anytime user's class is updated parses the user last location and returns
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[locations.count - 1] as CLLocation)
        guard let lastLocation = locations.first else {
            return
        }
    }
    
    ///
    ///locationManager function returns error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        locationManager.stopUpdatingLocation()
    }
    
    
    
    ///
    ///the checkLocationServicesStatus checks users location permissions
    ///
    /// - returns: True or False depending permission or pulling location
    func checkLocationServicesStatus()->Bool {
        var isStatusEnabled = false // isStatusEnabled will be false at the beginning
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied: // if notDetermined or restricted or denied return false
                isStatusEnabled  = false
            case .authorizedAlways, .authorizedWhenInUse: // if authorised return true
                isStatusEnabled =  true
            }
        } else {
            isStatusEnabled =  false // if LocatiınServiceEnabled == false return false
        }
        return isStatusEnabled
    }
}


