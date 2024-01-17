//
//  WeatherViewModel.swift
//  FindWeather
//
//  Created by Kathiravan on 12/01/24.
//

import Foundation

protocol WeatherViewModelProtocol {
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<([String:Any]?, WeatherModel?), Error>) -> Void)
    
    func fetchForecastData(latitude: Double, longitude: Double, completion: @escaping (Result<([String:Any]?, ForecastModel?), Error>) -> Void)
}

class WeatherViewModel: WeatherViewModelProtocol {
    
    private let service: APIService
    init(service: APIService) {
        self.service = service
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<([String:Any]?, WeatherModel?), Error>) -> Void) {
        let weatherURL = APIConstants.weatherURL(latitude: latitude, longitude: longitude)
        service.fetchData(type: WeatherModel.self, url: weatherURL, completion: completion)
    }
    
    func fetchForecastData(latitude: Double, longitude: Double, completion: @escaping (Result<([String:Any]?, ForecastModel?), Error>) -> Void) {
        let forecastURL = APIConstants.forecastURL(latitude: latitude, longitude: longitude)
        service.fetchData(type: ForecastModel.self, url: forecastURL, completion: completion)
    }
}
