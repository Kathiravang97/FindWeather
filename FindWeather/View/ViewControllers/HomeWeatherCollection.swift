//
//  HomeWeatherCollection.swift
//  FindWeather
//
//  Created by Kathiravan on 11/01/24.
//

import UIKit
import Foundation
import CoreLocation
import Kingfisher


class WeatherCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
}

extension HomeWeatherVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData?.daily.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell  = todayWeatherCollView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        if let weatherData = weatherData {
            let celsius = Utilise.fahrenheitToCelsius(fahrenheit: weatherData.main?.temp ?? 0)
            collCell.tempLabel.text = "\(celsius.rounded())"
            if let icon = forecastData?.daily[indexPath.row].weather[0].icon ,let imgURL = URL(string: "https://openweathermap.org/img/w/\(icon).png"), let desc = forecastData?.daily[indexPath.row].weather[0].description {
                collCell.weatherImage.kf.setImage(with: imgURL)
                collCell.descriptionLabel.text = desc
            }
        }
        return collCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}



