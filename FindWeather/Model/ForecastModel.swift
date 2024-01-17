//
//  WeatherModel.swift
//  FindWeather
//
//  Created by Kathiravan on 12/01/24.
//

import Foundation

struct ForecastModel: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]

    struct CurrentWeather: Codable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let weather: [WeatherDescription]
    }

    struct HourlyWeather: Codable {
        let dt: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double
        let weather: [WeatherDescription]
        let pop: Int
    }

    struct DailyWeather: Codable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let moonrise: Int
        let moonset: Int
        let moon_phase: Double
        let temp: Temperature
        let feels_like: FeelsLike
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double
        let weather: [WeatherDescription]
        let clouds: Int
        let pop: Int
        let uvi: Double
    }

    struct Temperature: Codable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    struct FeelsLike: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    struct WeatherDescription: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
