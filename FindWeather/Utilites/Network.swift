
import Foundation
import UIKit
import Reachability

class NetworkManager {
    static let shared = NetworkManager()
    
    private let reachability = try! Reachability()
    private init() {}
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc private func networkStatusChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                NetworkConstant.isConnected = true
            case .unavailable:
                NetworkConstant.isConnected = false
                handleNetworkDisconnection()
            case .none:
                print("Unknown connection")
            }
        }
    }
    
    private func handleNetworkDisconnection() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

