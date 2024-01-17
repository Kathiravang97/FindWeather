//
//  WeatherModel.swift
//  FindWeather
//
//  Created by Kathiravan on 12/01/24.
//

import Foundation

struct APIConstants {
    static var isModelDecoded: Bool = false
    static let apiKey = "4cd569ffb3ecc3bffe9c0587ff02109f"
    static let baseURL = "https://api.openweathermap.org/data/2.5/"


    static func weatherURL(latitude: Double, longitude: Double) -> URL {
        let urlString = "\(baseURL)weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return URL(string: urlString)!
    }

    static func forecastURL(latitude: Double, longitude: Double) -> URL {
        let urlString = "\(baseURL)onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return URL(string: urlString)!
    }
}

struct NetworkConstant {
    static var isConnected: Bool = false
}
