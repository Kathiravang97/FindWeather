//
//  SearchTableVC.swift
//  FindWeather
//
//  Created by Kathiravan on 11/01/24.
//

import Foundation
import UIKit


extension SearchLocationWeatherVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if APIConstants.isModelDecoded {
            return forecastData?.daily.count ?? 0
        } else if APIConstants.isModelDecoded == false {
            return dailyDataArray.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabCell = tempListTable.dequeueReusableCell(withIdentifier: "TempListTable", for: indexPath) as! TempListTable
        if APIConstants.isModelDecoded, let daily = forecastData?.daily[indexPath.row] {
            if let forecastModel = forecastData {
                tabCell.descriptionLabel.text = forecastModel.daily[indexPath.row].weather[0].description
                var temp = Double(forecastModel.daily[indexPath.row].temp.day)
                temp = Utilise.fahrenheitToCelsius(fahrenheit: Double(temp))
                tabCell.tempLabel.text = String(temp.rounded())
                if let icon = forecastData?.daily[indexPath.row].weather[0].icon ,let imgURL = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
                    tabCell.weatherImage.kf.setImage(with: imgURL)
                }
            }
        }else if !APIConstants.isModelDecoded, let daily = dailyDataArray[indexPath.row] as? [String: Any] {
            // Handle data from dailyDataArray
            let daily =  dailyDataArray[indexPath.row]
            let weatherData = daily["weather"] as? [[String:Any]]
            if let weatherArray = daily["weather"] as? [[String:Any]], let weatherDict = weatherArray[0] as? [String:Any]  {
                tabCell.descriptionLabel.text = weatherDict["description"] as? String
                var temp = daily["temp"] as? [String:Any]
                if let tempDay = temp?["day"] as? Double {
                    let dayTemp = tempDay
                    tabCell.tempLabel.text = String(Utilise.fahrenheitToCelsius(fahrenheit: dayTemp))
                }
                if let icon = weatherDict["icon"] ,let imgURL = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
                    tabCell.weatherImage.kf.setImage(with: imgURL)
                }
            }
        }
        return tabCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class TempListTable : UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
}
