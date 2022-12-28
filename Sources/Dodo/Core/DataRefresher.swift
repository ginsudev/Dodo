//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit

// MARK: - Public

final class DataRefresher {
    static let shared = DataRefresher()
    private var timer = Timer()
    var timerRunning = false
    var screenOn = false
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name("Dodo.updateTimeAndDate"),
            object: nil
        )
    }
    
    public func toggleTimer(on enable: Bool) {
        guard PreferenceManager.shared.settings.timeMediaPlayerStyle != .mediaPlayer else {
            // Do not start a timer for time/date updates because the user disabled Dodo's clock.
            refreshOnce()
            return
        }
        
        guard enable else {
            // If `false` was passed in, invalidate the timer and return, don't start another timer.
            if self.timer.isValid {
                self.timer.invalidate()
                timerRunning = false
            }
            return
        }
        
        guard !self.timer.isValid else {
            // Do not start a timer if one already exists.
            return
        }
        
        // Safety checks passed, start timer.
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(refresh),
            userInfo: nil,
            repeats: true
        )
        // Fire the timer imediately (this happens once).
        self.timer.fire()
        // Update timer status.
        timerRunning = true
        // Update values that only need to be updated once.
        refreshOnce()
    }
}

// MARK: - Private

private extension DataRefresher {
    @objc func refresh() {
        // Refresh time and date
        TimeDateView.ViewModel.shared.update(
            timeTemplate: PreferenceManager.shared.settings.timeTemplate,
            dateTemplate: PreferenceManager.shared.settings.dateTemplate
        )
    }
    
    func refreshOnce() {
        // Update the weather
        if PreferenceManager.shared.settings.showWeather {
            WeatherView.ViewModel.shared.updateWeather()
        }
        // Charging indication
        if PreferenceManager.shared.settings.hasChargingIndication,
           PreferenceManager.shared.settings.hasChargingFlash,
           UIDevice.current.batteryState != .unplugged {
            chargingIndication()
        }
    }
    
    func chargingIndication() {
        let chargeColour = UIColor(red: 0.28, green: 0.57, blue: 0.18, alpha: 1.00)
        let prevColour = MediaPlayer.ViewModel.shared.artworkColour
        MediaPlayer.ViewModel.shared.artworkColour = chargeColour
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            guard MediaPlayer.ViewModel.shared.artworkColour == chargeColour else {
                return
            }
            MediaPlayer.ViewModel.shared.artworkColour = prevColour
        }
    }
}
