//
//  SearchLocationWeatherVC.swift
//  FindWeather
//
//  Created by Kathiravan on 11/01/24.
//

import UIKit
import CoreLocation

class SearchLocationWeatherVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tempListTable: UITableView! {
        didSet {
            self.tempListTable.delegate = self
            self.tempListTable.dataSource = self
        }
    }
    var finalLatitude = 0
    var finalLongitude = 0
    var weatherViewModel: WeatherViewModelProtocol?
    var forecastData : ForecastModel?
    var dailyDataArray: [[String:Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            self.getCoordinates(from: searchText) { coordinates, error in
                guard error == nil else {return}
                if let currentCoordinates = coordinates {
                    self.finalLatitude = Int(currentCoordinates.latitude)
                    self.finalLongitude = Int(currentCoordinates.longitude)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if NetworkConstant.isConnected {
            self.view.startLoader()
            fetchSearchLocation()
        }
    }
    
    func fetchSearchLocation() {
        weatherViewModel?.fetchForecastData(latitude:  Double(self.finalLatitude), longitude: Double(self.finalLongitude), completion: { response in
            DispatchQueue.main.async {
                self.view.stopLoader()
            }
            switch response {
            case .success(let success):
                if let forecastResponse = success.1 {
                    self.forecastData = forecastResponse
                    APIConstants.isModelDecoded = true
                    DispatchQueue.main.async {
                        self.tempListTable.reloadData()
                    }
                } else if let forecastJsonData = success.0 {
                    if let dailyData = forecastJsonData["daily"] as? [[String:Any]] {
                        self.dailyDataArray = dailyData
                        APIConstants.isModelDecoded = false
                        DispatchQueue.main.async {
                            self.tempListTable.reloadData()
                        }
                    }
                }
            case .failure(let failure):
                print("-----Failure", failure.localizedDescription)
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("----end",searchBar.text ?? "")
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            if let firstPlacemark = placemarks?.first,
               let location = firstPlacemark.location?.coordinate {
                completion(location, nil)
            } else {
                print("No location found for address: \(address)")
                completion(nil, nil)
            }
        }
    }
}
