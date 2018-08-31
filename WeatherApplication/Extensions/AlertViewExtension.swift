//
//  AlertViewExtension.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 27/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation

import Foundation
import  UIKit
//General purpose Alertview Controller
//it can be called in anywhere and can display alertview
extension UIViewController {
    func displayMsg(title : String?, msg : String,
                    style: UIAlertControllerStyle = .alert,
                    dontRemindKey : String? = nil) {
        if dontRemindKey != nil,
            UserDefaults.standard.bool(forKey: dontRemindKey!) == true {
            return
        }
        
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: nil))
        //if do not remind key not nil add the button
        if dontRemindKey != nil {
            ac.addAction(UIAlertAction.init(title: "Don't Remind",
                                            style: .default, handler: { (aa) in
                                                UserDefaults.standard.set(true, forKey: dontRemindKey!)
                                                UserDefaults.standard.synchronize()
            }))
        }
        DispatchQueue.main.async {
            //present alertview controller
            self.present(ac, animated: true, completion: nil)
        }
    }
}
