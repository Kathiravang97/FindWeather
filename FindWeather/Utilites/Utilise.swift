//
//  Utilise.swift
//  FindWeather
//
//  Created by Friend on 16/01/24.
//

import UIKit
import Foundation



import UIKit

class Utilise: NSObject {
    
    class func fahrenheitToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8.rounded()
    }
    
    class func popUpAlert(from viewController: UIViewController = (UIApplication.shared.windows.first?.rootViewController)!, title: String, message: String, actionTitles: [String], actionStyle: [UIAlertAction.Style], action: @escaping ([UIAlertAction]) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var alertActions = [UIAlertAction]()
        for (index, actionTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: actionTitle, style: actionStyle[0], handler: { _ in
                action(alertActions)})
            alertActions.append(action)
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func jsonStringToDictionary(_ jsonString: String) -> [String: Any]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return dictionary
                }
            } catch {
                print("Error converting JSON string to dictionary: \(error)")
            }
        }
        return nil
    }
}
