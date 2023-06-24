//
//  LocationProvider.swift
//  
//
//  Created by Noah Little on 19/6/2023.
//

import Foundation
import CoreLocation
import Combine

final class LocationProvider: NSObject, CLLocationManagerDelegate {
    private var bag: Set<AnyCancellable> = []
    private let locationManager: CLLocationManager
    
    var location = PassthroughSubject<CLLocation?, Never>()
    
    override init() {
        // Need to fake as another app, because SpringBoard never asks for location permissions.
        self.locationManager = .init(effectiveBundleIdentifier: "com.apple.weather")
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func set(isUpdatingLocation: Bool) {
        if isUpdatingLocation {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.send(locations.last)
    }
}
