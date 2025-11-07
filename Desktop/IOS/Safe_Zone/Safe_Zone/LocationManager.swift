//
//  LocationManager.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: ((CLLocation?) -> Void)? = nil) {
        locationCompletion = completion
        locationError = nil
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable location services in Settings."
            locationCompletion?(nil)
            locationCompletion = nil
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            locationError = "Unknown location authorization status"
            locationCompletion?(nil)
            locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        locationError = nil
        print("Location updated: \(userLocation?.coordinate.latitude ?? 0), \(userLocation?.coordinate.longitude ?? 0)")
        locationCompletion?(userLocation)
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
        locationError = error.localizedDescription
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                locationError = "Location unavailable - trying again"
                manager.requestLocation()
            case .denied:
                locationError = "Location access denied. Please enable in Settings."
            case .network:
                locationError = "Network error - please check connection"
            default:
                locationError = "Location error: \(clError.code.rawValue)"
            }
        }
        locationCompletion?(nil)
        locationCompletion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable location services in Settings."
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}


