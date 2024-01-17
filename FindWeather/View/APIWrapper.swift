//
//  WeatherService.swift
//  FindWeather
//
//  Created by Kathiravan on 12/01/24.
//

import Foundation

protocol APIService {
    func fetchData<T: Codable>(type: T.Type, url: URL, completion: @escaping (Result<([String:Any]?, T?), Error>) -> Void)
}

class APIWrapper: APIService {
    func fetchData<T: Codable>(type: T.Type, url: URL, completion: @escaping (Result<([String:Any]?, T?), Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let forecastData = try decoder.decode(T.self, from: data)
                    let jString = String(data: data, encoding: .utf8)
                    let jData = Utilise.jsonStringToDictionary(jString!)
                    completion(.success((jData,forecastData)))
                } catch {
                    // If decoding fails, fallback to JSON serialization
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            let jData = Utilise.jsonStringToDictionary(jsonString)
                            completion(.success((jData,nil)))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case 404:
                // Handle 404 Not Found error
                completion(.failure(NSError(domain: "Not Found", code: 404, userInfo: nil)))
                
            default:
                // Handle other status codes as errors
                let httpError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(httpError))
            }
        }
        task.resume()
    }
}
