//
//  APIClient.swift
//  WeatherApplication
//
//  Created by Serhan Khan on 26/08/2018.
//  Copyright © 2018 Serhan Khan. All rights reserved.
//

import Foundation

protocol APIClient {
    var session:URLSession {get}
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}
